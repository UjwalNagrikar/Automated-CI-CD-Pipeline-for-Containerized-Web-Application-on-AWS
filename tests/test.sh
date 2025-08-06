#!/bin/bash

echo "🧪 Running tests for static web application..."

# Test 1: Check if HTML files exist
echo "📄 Checking HTML files..."
if [ ! -f "public/index.html" ]; then
    echo "❌ index.html not found"
    exit 1
fi
echo "✅ HTML files exist"

# Test 2: Check if CSS files exist
echo "🎨 Checking CSS files..."
if [ ! -f "public/style.css" ]; then
    echo "❌ style.css not found"
    exit 1
fi
echo "✅ CSS files exist"

# Test 3: Check if JavaScript files exist
echo "📜 Checking JavaScript files..."
if [ ! -f "public/script.js" ]; then
    echo "❌ script.js not found"
    exit 1
fi
echo "✅ JavaScript files exist"

# Test 4: Validate HTML syntax (basic)
echo "🔍 Validating HTML syntax..."
if ! grep -q "<!DOCTYPE html>" public/index.html; then
    echo "❌ HTML DOCTYPE not found"
    exit 1
fi

if ! grep -q "<title>" public/index.html; then
    echo "❌ HTML title not found"
    exit 1
fi
echo "✅ HTML syntax validation passed"

# Test 5: Check CSS syntax (basic)
echo "🎭 Validating CSS syntax..."
if ! grep -q "{" public/style.css; then
    echo "❌ CSS syntax error - no opening braces found"
    exit 1
fi
echo "✅ CSS syntax validation passed"

# Test 6: Check JavaScript syntax (basic)
echo "⚡ Validating JavaScript syntax..."
if command -v node >/dev/null 2>&1; then
    if ! node -c public/script.js; then
        echo "❌ JavaScript syntax error"
        exit 1
    fi
    echo "✅ JavaScript syntax validation passed"
else
    echo "⚠️ Node.js not available, skipping JS syntax check"
fi

# Test 7: Check for security issues (basic)
echo "🔒 Checking for basic security issues..."
if grep -i "eval(" public/script.js; then
    echo "❌ Potential security issue: eval() found"
    exit 1
fi

if grep -i "innerHTML.*+" public/script.js; then
    echo "⚠️ Warning: Direct innerHTML concatenation found (potential XSS)"
fi
echo "✅ Basic security check passed"

# Test 8: Check file sizes
echo "📏 Checking file sizes..."
HTML_SIZE=$(stat -f%z public/index.html 2>/dev/null || stat -c%s public/index.html 2>/dev/null)
CSS_SIZE=$(stat -f%z public/style.css 2>/dev/null || stat -c%s public/style.css 2>/dev/null)
JS_SIZE=$(stat -f%z public/script.js 2>/dev/null || stat -c%s public/script.js 2>/dev/null)

echo "   HTML: ${HTML_SIZE} bytes"
echo "   CSS:  ${CSS_SIZE} bytes"
echo "   JS:   ${JS_SIZE} bytes"

if [ "$HTML_SIZE" -gt 100000 ]; then
    echo "⚠️ Warning: HTML file is quite large (${HTML_SIZE} bytes)"
fi
echo "✅ File size check completed"

echo ""
echo "🎉 All tests passed! Application is ready for deployment."
echo ""