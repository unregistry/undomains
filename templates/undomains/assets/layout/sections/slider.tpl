<!-- Slider Section -->
<div class="main-container slider">
    <div class="silder-container">
        <!-- Three.js Background Animation -->
        <div class="hero-threejs-bg" id="hero-threejs-bg"></div>
        <div class="carousel header-main-slider">
            <!-- Domain Search Slide -->
            <div class="carousel-cell overlay">
                <div class="slider-content">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-lg-7 mx-auto text-center">
                                <h1 class="text-gold">Find your perfect domain name</h1>
                                <p>We are in preview mode for the upcoming new gTLD application round and reservation system.<br>Orders cannot be completed at the moment. Search Only.</p>

                                <form class="domain-search-simple" id="frmDomainHomepage" onsubmit="return handleDomainSearch(event)">
                                    <div class="domain-search-wrapper" style="justify-content: center;">
                                        <input type="text"
                                               class="form-control domain-input"
                                               name="domain"
                                               id="domainSearchInput"
                                               placeholder="Enter your domain name..."
                                               autocapitalize="none"
                                               autocorrect="off"
                                               spellcheck="false" />
                                        <button type="submit" class="btn btn-search">
                                            <i class="fas fa-search"></i> Search
                                        </button>
                                    </div>
                                </form>
                                <script>
                                function handleDomainSearch(e) {
                                    e.preventDefault();
                                    var domain = document.getElementById('domainSearchInput').value.trim().toLowerCase();
                                    if (domain) {
                                        // Default to .com if no extension provided
                                        if (domain.indexOf('.') === -1) {
                                            domain = domain + '.com';
                                        }
                                        window.location.href = '/search/' + encodeURIComponent(domain);
                                    }
                                    return false;
                                }
                                </script>

                                <div class="domain-pricing" data-aos="fade-up" data-aos-duration="1400">
                                    <span>.com as low as <strong>$11.00</strong></span>
                                </div>
                            </div>
                            <div class="col-lg-5 d-none d-lg-block">
                                <div class="hero-illustration">
                                    <img src="{$WEB_ROOT}/templates/{$template}/assets/patterns/domainmanage.svg" alt="Domain Search" class="img-fluid">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="silder-video">
                    <div class="cover-wrapper">
                        <video class="cover-video" autoplay loop muted playsinline>
                            <source src="{$WEB_ROOT}/templates/{$template}/assets/videos/planet.mp4" type="video/mp4">
                        </video>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* Main slider container */
.main-container.slider {
    background-color: transparent !important;
}

/* Hero Three.js Background - must be behind content */
.hero-threejs-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    pointer-events: none;
}

.hero-threejs-bg canvas {
    display: block;
    width: 100%;
    height: 100%;
}

/* Slider container - dark by default */
.silder-container {
    background-color: #101010 !important;
    position: relative !important;
}

/* Make carousel transparent */
.carousel.header-main-slider {
    background-color: transparent !important;
    position: relative;
    z-index: 2;
}

/* Carousel overlay - push the dark overlay behind Three.js */
.carousel-cell.overlay {
    background-color: transparent !important;
    position: relative;
    z-index: 2;
}

/* Hide the dark overlay completely */
.carousel-cell.overlay:before {
    display: none !important;
}

/* Hide the video element */
.silder-video,
.silder-video .cover-wrapper,
.silder-video video {
    display: none !important;
}

/* Slider content above Three.js */
.slider-content {
    position: relative;
    z-index: 3;
}

/* Light theme - white background */
[data-background="light"] .silder-container {
    background-color: #fff !important;
}

/* Light theme - dark text */
[data-background="light"] .slider-content p {
    color: #333 !important;
}
[data-background="light"] .domain-pricing {
    color: #333 !important;
}
[data-background="light"] .domain-pricing span {
    color: #333 !important;
}
[data-background="light"] .slider-content h1 {
    color: #1a1a2e !important;
}
[data-background="light"] .text-gold {
    color: #D4AF37 !important;
}

.text-gold {
    color: #cc9933 !important;
}

/* Simplified Domain Search Styles */
.domain-search-simple {
    max-width: 600px;
    margin: 0 auto;
}

.domain-search-wrapper {
    display: flex;
    gap: 10px;
    border: 1px solid #fff;
    border-radius: 50px;
    padding: 8px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

/* Light theme - black border */
[data-background="light"] .domain-search-wrapper {
    border: 1px solid #000;
}

.domain-search-wrapper:focus-within {
    transform: translateY(-2px);
    box-shadow: 0 15px 50px rgba(0,0,0,0.15);
}

.domain-input {
    flex: 1;
    border: none !important;
    padding: 15px 25px !important;
    font-size: 16px;
    outline: none !important;
    border-radius: 40px !important;
    background-color: #fff !important;
    color: #333 !important;
}

/* Light theme input */
[data-background="light"] .domain-input {
    background-color: #fff !important;
    color: #333 !important;
}

.btn-search {
    background: linear-gradient(135deg, #D4AF37 0%, #cc9933 100%);
    border: none;
    color: #000;
    padding: 15px 35px;
    border-radius: 40px;
    font-weight: 600;
    transition: all 0.3s ease;
    white-space: nowrap;
}

.btn-search:hover {
    transform: scale(1.02);
    box-shadow: 0 5px 20px rgba(204, 153, 51, 0.4);
}

.domain-pricing {
    margin-top: 20px;
    font-size: 16px;
    opacity: 0.9;
    color: #fff !important;
    text-align: center;
}

.domain-pricing span {
    color: #fff !important;
}

.domain-pricing strong {
    color: #CC9933;
    font-size: 18px;
}

.hero-illustration {
    position: relative;
    animation: float 6s ease-in-out infinite;
}

@keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-20px); }
}

/* Disable slider navigation since we only have one slide */
.header-main-slider .flickity-prev-next-button {
    display: none !important;
}

.header-main-slider .flickity-page-dots {
    display: none !important;
}

</style>

<!-- Three.js Network Animation Script -->
<script>
(function() {
    if (typeof THREE === 'undefined') {
        console.warn('Three.js not loaded');
        return;
    }

    const CONFIG = {
        particleCount: 80,
        connectionDistance: 200,
        particleSpeed: 0.3,
        rotationSpeed: 0.0003,
        // Colors for different themes
        darkModeColor: 0xD4AF37,   // Gold for dark mode
        lightModeColor: 0x5D4E37,  // Dark bronze/brown for light mode
        darkLineColor: 0xD4AF37,
        lightLineColor: 0x8B7355   // Medium bronze for connections in light mode
    };

    let scene, camera, renderer, particles, lines;
    let mouseX = 0, mouseY = 0;
    let container;

    function isLightMode() {
        // Check document.body (always exists and has data-background set)
        return document.body.getAttribute('data-background') === 'light';
    }

    function getParticleColor() {
        return isLightMode() ? CONFIG.lightModeColor : CONFIG.darkModeColor;
    }

    function getLineColor() {
        return isLightMode() ? CONFIG.lightLineColor : CONFIG.darkLineColor;
    }

    function init() {
        container = document.getElementById('hero-threejs-bg');
        if (!container) {
            console.warn('Three.js container not found');
            return;
        }

        console.log('Initializing Three.js hero animation...');
        console.log('Light mode:', isLightMode());

        scene = new THREE.Scene();

        const width = container.offsetWidth || window.innerWidth;
        const height = container.offsetHeight || 600;

        camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
        camera.position.z = 400;

        renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
        renderer.setSize(width, height);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        renderer.setClearColor(0x000000, 0);
        container.appendChild(renderer.domElement);

        console.log('Three.js canvas created:', width, 'x', height);

        createParticles();
        createLines();

        window.addEventListener('resize', onWindowResize);
        document.addEventListener('mousemove', onMouseMove);

        // Listen for theme changes on body
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.attributeName === 'data-background') {
                    updateColors();
                }
            });
        });
        observer.observe(document.body, { attributes: true });

        animate();
    }

    function createParticles() {
        const geometry = new THREE.BufferGeometry();
        const positions = new Float32Array(CONFIG.particleCount * 3);
        const velocities = [];

        for (let i = 0; i < CONFIG.particleCount; i++) {
            positions[i * 3] = (Math.random() - 0.5) * 800;
            positions[i * 3 + 1] = (Math.random() - 0.5) * 600;
            positions[i * 3 + 2] = (Math.random() - 0.5) * 400;
            velocities.push({
                x: (Math.random() - 0.5) * CONFIG.particleSpeed,
                y: (Math.random() - 0.5) * CONFIG.particleSpeed,
                z: (Math.random() - 0.5) * CONFIG.particleSpeed
            });
        }

        geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));

        const material = new THREE.PointsMaterial({
            color: getParticleColor(),
            size: 3,
            transparent: true,
            opacity: 0.8,
            sizeAttenuation: true
        });

        particles = new THREE.Points(geometry, material);
        particles.velocities = velocities;
        scene.add(particles);
    }

    function createLines() {
        const material = new THREE.LineBasicMaterial({
            color: getLineColor(),
            transparent: true,
            opacity: 0.15
        });
        const geometry = new THREE.BufferGeometry();
        lines = new THREE.LineSegments(geometry, material);
        scene.add(lines);
    }

    function updateColors() {
        if (particles && particles.material) {
            particles.material.color.setHex(getParticleColor());
        }
        if (lines && lines.material) {
            lines.material.color.setHex(getLineColor());
        }
        console.log('Three.js colors updated for', isLightMode() ? 'light' : 'dark', 'mode');
    }

    function updateLines() {
        const positions = particles.geometry.attributes.position.array;
        const linePositions = [];

        for (let i = 0; i < CONFIG.particleCount; i++) {
            for (let j = i + 1; j < CONFIG.particleCount; j++) {
                const dx = positions[i * 3] - positions[j * 3];
                const dy = positions[i * 3 + 1] - positions[j * 3 + 1];
                const dz = positions[i * 3 + 2] - positions[j * 3 + 2];
                const distance = Math.sqrt(dx * dx + dy * dy + dz * dz);

                if (distance < CONFIG.connectionDistance) {
                    linePositions.push(
                        positions[i * 3], positions[i * 3 + 1], positions[i * 3 + 2],
                        positions[j * 3], positions[j * 3 + 1], positions[j * 3 + 2]
                    );
                }
            }
        }

        lines.geometry.setAttribute('position', new THREE.Float32BufferAttribute(linePositions, 3));
    }

    function onWindowResize() {
        if (!container) return;
        const width = container.offsetWidth || window.innerWidth;
        const height = container.offsetHeight || 600;
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
        renderer.setSize(width, height);
    }

    function onMouseMove(event) {
        mouseX = (event.clientX - window.innerWidth / 2) * 0.5;
        mouseY = (event.clientY - window.innerHeight / 2) * 0.5;
    }

    function animate() {
        requestAnimationFrame(animate);

        const positions = particles.geometry.attributes.position.array;
        const velocities = particles.velocities;

        for (let i = 0; i < CONFIG.particleCount; i++) {
            positions[i * 3] += velocities[i].x;
            positions[i * 3 + 1] += velocities[i].y;
            positions[i * 3 + 2] += velocities[i].z;

            if (positions[i * 3] > 400) positions[i * 3] = -400;
            if (positions[i * 3] < -400) positions[i * 3] = 400;
            if (positions[i * 3 + 1] > 300) positions[i * 3 + 1] = -300;
            if (positions[i * 3 + 1] < -300) positions[i * 3 + 1] = 300;
            if (positions[i * 3 + 2] > 200) positions[i * 3 + 2] = -200;
            if (positions[i * 3 + 2] < -200) positions[i * 3 + 2] = 200;
        }

        particles.geometry.attributes.position.needsUpdate = true;
        updateLines();

        scene.rotation.y += (mouseX * 0.00001 - scene.rotation.y) * 0.05;
        scene.rotation.x += (-mouseY * 0.00001 - scene.rotation.x) * 0.05;
        scene.rotation.y += CONFIG.rotationSpeed;

        renderer.render(scene, camera);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
</script>
