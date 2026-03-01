package handlers

import (
	"database/sql"
	"net/http"

	"github.com/Ademayowa/k8s-api-deployment/internal/models"

	"github.com/gin-gonic/gin"
)

// Create a property
func CreateProperty(ctx *gin.Context) {
	var property models.Property

	err := ctx.ShouldBindJSON(&property)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "could not parse property data"})
		return
	}

	err = property.Save()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "could not save property"})
		return
	}

	ctx.JSON(http.StatusCreated, gin.H{"message": "property created!", "property": property})
}

// Get all properties
func GetProperties(ctx *gin.Context) {
	properties, err := models.GetAllProperties()

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "could not fetch properties"})
		return
	}

	ctx.JSON(http.StatusOK, properties)
}

// Get a single property
func GetProperty(ctx *gin.Context) {
	id := ctx.Param("id")

	property, err := models.GetPropertyByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "property not found"})
			return
		}
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "could not retrieve property"})
		return
	}

	ctx.JSON(http.StatusOK, property)
}

// Health check endpoint for liveness probe
func HealthCheck(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, gin.H{"status": "app is healthy"})
}

// Readiness check endpoint for readiness probe
func ReadinessCheck(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, gin.H{"status": "app is ready to receive traffic"})
}
