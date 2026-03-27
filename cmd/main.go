package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	db "github.com/Ademayowa/k8s-api-deployment/internal/database"
	"github.com/Ademayowa/k8s-api-deployment/internal/handlers"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	godotenv.Load()

	db.InitDB()
	defer db.Close()

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Public server - Gin router
	router := gin.Default()
	handlers.RegisterRoutes(router)
	appSrv := &http.Server{Addr: ":" + port, Handler: router}

	// Internal metrics server - never exposed via Traefik
	metricsSrv := &http.Server{
		Addr:    ":9091",
		Handler: promhttp.Handler(),
	}

	go appSrv.ListenAndServe()
	go metricsSrv.ListenAndServe()

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt, syscall.SIGTERM)
	<-stop

	log.Println("Shutting down...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	appSrv.Shutdown(ctx)
	metricsSrv.Shutdown(ctx)

	log.Println("Server stopped")
}
