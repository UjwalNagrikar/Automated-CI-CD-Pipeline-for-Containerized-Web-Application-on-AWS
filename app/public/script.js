// Initialize page when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    loadContainerInfo();
    setInterval(updateTime, 1000);
});

// Load container and deployment information
function loadContainerInfo() {
    // Generate container ID (simulated)
    const containerId = 'ecs-' + Math.random().toString(36).substr(2, 9);
    document.getElementById('container-id').textContent = containerId;
    
    // Set deployment time
    const deployTime = new Date().toISOString().replace('T', ' ').substr(0, 19);
    document.getElementById('deployment-time').textContent = deployTime;
    
    // Get environment from URL parameters or default
    const urlParams = new URLSearchParams(window.location.search);
    const environment = urlParams.get('env') || 'Production';
    document.getElementById('environment').textContent = environment;
    
    // Get build version from URL parameters or default
    const buildVersion = urlParams.get('version') || 'v1.0.0';
    document.getElementById('build-version').textContent = buildVersion;
}

// Update current time
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString();
    
    // Update any time displays if they exist
    const timeElements = document.querySelectorAll('.current-time');
    timeElements.forEach(el => el.textContent = timeString);
}

// Health check function
function checkHealth() {
    const modal = document.getElementById('modal');
    const title = document.getElementById('modal-title');
    const body = document.getElementById('modal-body');
    
    title.innerHTML = '<i class="fas fa-heartbeat"></i> Health Check';
    
    // Simulate health check
    body.innerHTML = `
        <div style="text-align: center; padding: 20px;">
            <div style="margin-bottom: 20px;">
                <i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: #667eea;"></i>
                <p style="margin-top: 10px;">Performing health check...</p>
            </div>
        </div>
    `;
    
    modal.style.display = 'block';
    
    // Simulate API call delay
    setTimeout(() => {
        body.innerHTML = `
            <div style="text-align: center; padding: 20px;">
                <div style="margin-bottom: 20px;">
                    <i class="fas fa-check-circle" style="font-size: 3rem; color: #27ae60;"></i>
                    <h3 style="color: #27ae60; margin: 15px 0;">All Systems Operational</h3>
                </div>
                <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: left;">
                    <strong>Health Check Results:</strong><br>
                    ✅ Container Status: Running<br>
                    ✅ Memory Usage: 45% (230MB/512MB)<br>
                    ✅ CPU Usage: 12%<br>
                    ✅ Network: Connected<br>
                    ✅ Load Balancer: Healthy<br>
                    ✅ Response Time: 23ms
                </div>
                <div style="margin-top: 15px; color: #6c757d; font-size: 0.9rem;">
                    Last check: ${new Date().toLocaleString()}
                </div>
            </div>
        `;
    }, 2000);
}

// Refresh information
function refreshInfo() {
    const button = event.target.closest('.btn');
    const originalText = button.innerHTML;
    
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Refreshing...';
    button.disabled = true;
    
    // Simulate refresh delay
    setTimeout(() => {
        loadContainerInfo();
        button.innerHTML = originalText;
        button.disabled = false;
        
        // Show success message
        showNotification('Information refreshed successfully!', 'success');
    }, 1500);
}

// View logs function
function viewLogs() {
    const modal = document.getElementById('modal');
    const title = document.getElementById('modal-title');
    const body = document.getElementById('modal-body');
    
    title.innerHTML = '<i class="fas fa-file-alt"></i> Application Logs';
    
    const logs = [
        '[2025-08-06 10:30:15] INFO: Container started successfully',
        '[2025-08-06 10:30:16] INFO: Health check endpoint ready',
        '[2025-08-06 10:30:17] INFO: Load balancer target registered',
        '[2025-08-06 10:31:22] INFO: HTTP GET / - 200 OK',
        '[2025-08-06 10:31:45] INFO: HTTP GET /health - 200 OK',
        '[2025-08-06 10:32:10] INFO: HTTP GET / - 200 OK',
        '[2025-08-06 10:32:33] INFO: Memory usage: 45% (230MB/512MB)',
        '[2025-08-06 10:33:15] INFO: HTTP GET /health - 200 OK'
    ];
    
    body.innerHTML = `
        <div style="max-height: 300px; overflow-y: auto; background: #1e1e1e; color: #00ff00; padding: 15px; border-radius: 5px; font-family: 'Courier New', monospace; font-size: 0.9rem;">
            ${logs.map(log => `<div style="margin-bottom: 5px;">${log}</div>`).join('')}
            <div style="margin-top: 10px; color: #888;">--- End of logs ---</div>
        </div>
        <div style="margin-top: 15px; text-align: center;">
            <button onclick="downloadLogs()" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.9rem;">
                <i class="fas fa-download"></i> Download Full Logs
            </button>
        </div>
    `;
    
    modal.style.display = 'block';
}

// Download logs (simulated)
function downloadLogs() {
    showNotification('Log download started!', 'info');
}

// Show notification
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        border-radius: 10px;
        color: white;
        font-weight: bold;
        z-index: 1001;
        opacity: 0;
        transition: opacity 0.3s ease;
    `;
    
    const colors = {
        success: '#27ae60',
        error: '#e74c3c',
        info: '#3498db',
        warning: '#f39c12'
    };
    
    notification.style.backgroundColor = colors[type] || colors.info;
    notification.innerHTML = `<i class="fas fa-${type === 'success' ? 'check' : type === 'error' ? 'times' : 'info'}-circle"></i> ${message}`;
    
    document.body.appendChild(notification);
    
    // Fade in
    setTimeout(() => notification.style.opacity = '1', 100);
    
    // Remove after 3 seconds
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => document.body.removeChild(notification), 300);
    }, 3000);
}

// Modal close functionality
document.addEventListener('click', function(e) {
    const modal = document.getElementById('modal');
    if (e.target === modal || e.target.classList.contains('close')) {
        modal.style.display = 'none';
    }
});

// Add some interactive effects
document.addEventListener('mousemove', function(e) {
    const cards = document.querySelectorAll('.feature-card, .info-card');
    cards.forEach(card => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        if (x >= 0 && x <= rect.width && y >= 0 && y <= rect.height) {
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            const rotateX = (y - centerY) / 10;
            const rotateY = (centerX - x) / 10;
            
            card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateZ(10px)`;
        } else {
            card.style.transform = '';
        }
    });
});