#!/bin/bash

# Test script for DocuSign Automation Webhook
# Usage: ./test-webhook.sh [webhook_url]

set -e

# Configuration
WEBHOOK_URL=${1:-"http://localhost:5678/webhook/send-docusign"}
TEST_EMAIL="test@example.com"
TEST_NAME="Test User"
TEST_TEMPLATE="default-template"

echo "🧪 Testing DocuSign Automation Webhook"
echo "📍 URL: $WEBHOOK_URL"
echo "📧 Test Email: $TEST_EMAIL"
echo "👤 Test Name: $TEST_NAME"
echo "📄 Template: $TEST_TEMPLATE"
echo ""

# Test 1: Valid request
echo "✅ Test 1: Valid request"
response=$(curl -s -w "\n%{http_code}" -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "clientEmail": "'$TEST_EMAIL'",
    "clientName": "'$TEST_NAME'",
    "envelopeTemplate": "'$TEST_TEMPLATE'"
  }')

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

echo "Status Code: $http_code"
echo "Response: $body"
echo ""

# Test 2: Invalid email
echo "❌ Test 2: Invalid email format"
response=$(curl -s -w "\n%{http_code}" -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "clientEmail": "invalid-email",
    "clientName": "'$TEST_NAME'",
    "envelopeTemplate": "'$TEST_TEMPLATE'"
  }')

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

echo "Status Code: $http_code"
echo "Response: $body"
echo ""

# Test 3: Missing name
echo "❌ Test 3: Missing client name"
response=$(curl -s -w "\n%{http_code}" -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "clientEmail": "'$TEST_EMAIL'",
    "clientName": "",
    "envelopeTemplate": "'$TEST_TEMPLATE'"
  }')

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

echo "Status Code: $http_code"
echo "Response: $body"
echo ""

# Test 4: Minimal request (no template)
echo "✅ Test 4: Minimal request (default template)"
response=$(curl -s -w "\n%{http_code}" -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "clientEmail": "'$TEST_EMAIL'",
    "clientName": "'$TEST_NAME'"
  }')

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

echo "Status Code: $http_code"
echo "Response: $body"
echo ""

echo "🎉 Testing complete!"
