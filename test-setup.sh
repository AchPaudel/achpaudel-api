#!/bin/bash

echo "🧪 Testing Ach Paudel API Setup..."

# Check if Java is available
echo "📋 Checking Java installation..."
if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo "✅ Java found: $java_version"
else
    echo "❌ Java not found. Please install Java 17 or higher."
    exit 1
fi

# Check if Maven is available
echo "📋 Checking Maven installation..."
if command -v mvn &> /dev/null; then
    mvn_version=$(mvn -version 2>&1 | head -n 1)
    echo "✅ Maven found: $mvn_version"
else
    echo "❌ Maven not found. Please install Maven 3.6+"
    echo "   You can install it with: brew install maven"
    exit 1
fi

# Check project structure
echo "📋 Checking project structure..."
required_files=(
    "pom.xml"
    "src/main/java/com/achpaudel/api/AchPaudelApiApplication.java"
    "src/main/resources/application.yml"
    "src/main/java/com/achpaudel/api/controller/ApiController.java"
    "src/main/java/com/achpaudel/api/model/Project.java"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

echo "🎉 All checks passed! Your API server is ready to build and deploy."
echo ""
echo "Next steps:"
echo "1. Install Java 17 if not already installed"
echo "2. Install Maven if not already installed"
echo "3. Run: mvn clean install"
echo "4. Run: mvn spring-boot:run"
echo "5. Test the API at: http://localhost:8080/api/v1/health" 