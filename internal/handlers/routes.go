package handlers

import (
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func RegisterRoutes(server *gin.Engine) {
	server.Use(cors.New(cors.Config{
		AllowOrigins: []string{
			"http://localhost:3000",     // Next.js Frontend
			"http://localhost:8080",     // Local Golang APIs
			"http://test.example.local", // Ingress local
			"https://example.com",       // Production frontend
			"https://test.example.com",  // Production Golang APIs
		},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	server.GET("/properties", GetProperties)
	server.POST("/properties", CreateProperty)
	server.GET("/properties/:id", GetProperty)

	// Health check endpoints
	server.GET("/health", HealthCheck)
	server.GET("/ready", ReadinessCheck)
}
