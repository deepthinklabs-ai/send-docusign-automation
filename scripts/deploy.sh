#!/bin/bash

# Deployment script for DocuSign Automation
# Usage: ./deploy.sh [environment]

set -e

ENVIRONMENT=${1:-"development"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Deploying DocuSign Automation to $ENVIRONMENT"
echo "📁 Project Directory: $PROJECT_DIR"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Copy environment file
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo "📋 Creating .env file from template"
    cp "$PROJECT_DIR/.env.example" "$PROJECT_DIR/.env"
    echo "⚠️  Please edit .env file with your configuration before running again"
    echo "📝 Required variables:"
    echo "   - DOCUSIGN_INTEGRATION_KEY"
    echo "   - DOCUSIGN_USER_ID"
    echo "   - DOCUSIGN_ACCOUNT_ID"
    echo "   - N8N_BASIC_AUTH_PASSWORD"
    exit 1
fi

cd "$PROJECT_DIR"

# Environment-specific deployment
case $ENVIRONMENT in
    "development")
        echo "🔧 Starting development environment"
        docker-compose up -d
        ;;
    "production")
        echo "🏭 Starting production environment with database"
        docker-compose --profile postgres --profile redis up -d
        ;;
    "staging")
        echo "🎭 Starting staging environment"
        docker-compose --profile postgres up -d
        ;;
    *)
        echo "❌ Unknown environment: $ENVIRONMENT"
        echo "Available environments: development, staging, production"
        exit 1
        ;;
esac

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if n8n is running
if curl -f http://localhost:5678/healthz > /dev/null 2>&1; then
    echo "✅ n8n is running successfully!"
    echo "🌐 Access n8n at: http://localhost:5678"
    echo "📚 Webhook URL: http://localhost:5678/webhook/send-docusign"
else
    echo "❌ n8n is not responding. Check logs with: docker-compose logs n8n"
    exit 1
fi

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "Next steps:"
echo "1. Access n8n at http://localhost:5678"
echo "2. Import the workflow from workflows/send-docusign-automation.json"
echo "3. Configure DocuSign credentials in n8n"
echo "4. Test the webhook using scripts/test-webhook.sh"
echo ""
echo "To stop: docker-compose down"
echo "To view logs: docker-compose logs -f"
