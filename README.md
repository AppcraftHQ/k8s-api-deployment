# Kubernetes deployment for a Go REST API</h2>

## <a name="tech-stack">⚙️ Tech Stack</a>

- Go
- PostgreSQL
- Gin
- Docker
- Helm
- Kubernetes
- Terraform

## <a name="quick-start">🤸 Quick Start</a>

Follow these steps to set up the project locally on your machine.

**Prerequisites**

Make sure you have the following installed on your machine:

- [Go](https://go.dev/doc/install)
- [Gin](https://gin-gonic.com/docs/quickstart/)
- [Docker](https://www.docker.com/)

**Cloning the Repository**

```bash
git clone https://github.com/AppcraftHQ/k8s-api-deployment.git
```

## Setup

### 1. Install Dependencies

```bash
go mod tidy
```

### 2. Create a database on Supabase or any other PostgreSQL DB & get the connection strings.

### 3. Test the endpoint.

```bash
curl -X POST http://localhost:8080/properties \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Rent a two bedroom in Lisbon",
    "description": "Rent a cool two bedroom in Lisbon",
    "type": "apartment",
    "status": "for_rent",
    "price": 3000000,
    "bedrooms": 2,
    "bathrooms": 1,
    "size_sqm": 120,
    "address": "Portugal Lisbon",
    "images": [
      "https://example.com/images/property1_1.jpg",
      "https://example.com/images/property1_2.jpg"
    ]
  }'
```

Open [http://localhost:8080/properties](http://localhost:8080/properties) in your browser to view all jobs.
