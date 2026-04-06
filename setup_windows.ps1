# Axiom OS Windows Setup
Write-Host "🚀 Axiom OS Setup for Windows" -ForegroundColor Green

# Step 1: Install WSL 2
Write-Host "1. Installing WSL 2..." -ForegroundColor Cyan
wsl --install -d Ubuntu

Write-Host "⚠️ IMPORTANT: Please RESTART your PC." -ForegroundColor Red
Write-Host "After restarting, open the 'Ubuntu' app and run this command:" -ForegroundColor Yellow
Write-Host "bash <(curl -sSfL https://raw.githubusercontent.com/sanskar-0day/Axiom/main/bootstrap.sh)" -ForegroundColor White
