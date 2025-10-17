// 📚 Système de filtrage des docs - JavaScript côté client
// Placement : static/js/docs-filter.js

class DocsFilter {
    constructor() {
        this.init();
    }

    init() {
        this.createFilterUI();
        this.bindEvents();
        this.setupSearch();
    }

    createFilterUI() {
        const filterHTML = `
            <div class="docs-filter-container mb-4">
                <div class="row g-3">
                    <!-- Filtres par catégorie -->
                    <div class="col-md-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-filter me-2"></i>Catégorie
                        </label>
                        <select id="categoryFilter" class="form-select">
                            <option value="">Toutes les catégories</option>
                            <option value="projet">🚀 Projets</option>
                            <option value="guide">📚 Guides</option>
                            <option value="note">📝 Notes</option>
                            <option value="api">⚡ API</option>
                        </select>
                    </div>

                    <!-- Filtres par technologie -->
                    <div class="col-md-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-code me-2"></i>Technologie
                        </label>
                        <select id="techFilter" class="form-select">
                            <option value="">Toutes les technologies</option>
                            <!-- Dynamiquement peuplé -->
                        </select>
                    </div>

                    <!-- Recherche textuelle -->
                    <div class="col-md-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-search me-2"></i>Recherche
                        </label>
                        <input type="text" id="searchInput" class="form-control" 
                               placeholder="Rechercher dans les docs...">
                    </div>
                </div>

                <!-- Compteur de résultats -->
                <div class="mt-3">
                    <small class="text-muted">
                        <span id="resultsCount">0</span> document(s) trouvé(s)
                    </small>
                    <button id="clearFilters" class="btn btn-sm btn-outline-secondary ms-2">
                        <i class="fas fa-times me-1"></i>Effacer filtres
                    </button>
                </div>
            </div>
        `;

        // Insérer avant la grille de docs
        const docsGrid = document.querySelector('.row.g-4');
        if (docsGrid) {
            docsGrid.insertAdjacentHTML('beforebegin', filterHTML);
        }
    }

    bindEvents() {
        // Événements de filtrage
        document.getElementById('categoryFilter')?.addEventListener('change', () => this.applyFilters());
        document.getElementById('techFilter')?.addEventListener('change', () => this.applyFilters());
        document.getElementById('searchInput')?.addEventListener('input', () => this.applyFilters());
        document.getElementById('clearFilters')?.addEventListener('click', () => this.clearAllFilters());
    }

    setupSearch() {
        // Extraire toutes les technologies des articles
        this.extractTechnologies();
        // Compter les docs initialement
        this.updateResultsCount();
    }

    extractTechnologies() {
        const techSet = new Set();
        document.querySelectorAll('[data-tags]').forEach(card => {
            const tags = card.dataset.tags.split(',');
            tags.forEach(tag => {
                // Filtrer les technologies (exclure 'projet', 'guide', etc.)
                if (!['projet', 'guide', 'note', 'api', 'test'].includes(tag.trim())) {
                    techSet.add(tag.trim());
                }
            });
        });

        // Peupler le select des technologies
        const techFilter = document.getElementById('techFilter');
        if (techFilter) {
            techSet.forEach(tech => {
                const option = document.createElement('option');
                option.value = tech;
                option.textContent = tech.charAt(0).toUpperCase() + tech.slice(1);
                techFilter.appendChild(option);
            });
        }
    }

    applyFilters() {
        const categoryFilter = document.getElementById('categoryFilter')?.value || '';
        const techFilter = document.getElementById('techFilter')?.value || '';
        const searchTerm = document.getElementById('searchInput')?.value.toLowerCase() || '';

        const docCards = document.querySelectorAll('.doc-card, .project-card');
        let visibleCount = 0;

        docCards.forEach(card => {
            let isVisible = true;

            // Filtre par catégorie
            if (categoryFilter) {
                const tags = card.dataset.tags || '';
                if (!tags.includes(categoryFilter)) {
                    isVisible = false;
                }
            }

            // Filtre par technologie
            if (techFilter && isVisible) {
                const tags = card.dataset.tags || '';
                if (!tags.includes(techFilter)) {
                    isVisible = false;
                }
            }

            // Filtre par recherche textuelle
            if (searchTerm && isVisible) {
                const title = card.querySelector('.card-title')?.textContent.toLowerCase() || '';
                const description = card.querySelector('.card-text')?.textContent.toLowerCase() || '';
                const tags = card.dataset.tags || '';
                
                if (!title.includes(searchTerm) && 
                    !description.includes(searchTerm) && 
                    !tags.toLowerCase().includes(searchTerm)) {
                    isVisible = false;
                }
            }

            // Appliquer la visibilité
            const cardContainer = card.closest('.col-lg-6, .col-xl-4');
            if (cardContainer) {
                cardContainer.style.display = isVisible ? 'block' : 'none';
                if (isVisible) visibleCount++;
            }
        });

        this.updateResultsCount(visibleCount);
        this.highlightActiveFilters();
    }

    clearAllFilters() {
        document.getElementById('categoryFilter').value = '';
        document.getElementById('techFilter').value = '';
        document.getElementById('searchInput').value = '';
        this.applyFilters();
    }

    updateResultsCount(count = null) {
        if (count === null) {
            count = document.querySelectorAll('.doc-card, .project-card').length;
        }
        
        const counter = document.getElementById('resultsCount');
        if (counter) {
            counter.textContent = count;
        }
    }

    highlightActiveFilters() {
        const filters = ['categoryFilter', 'techFilter'];
        filters.forEach(filterId => {
            const filter = document.getElementById(filterId);
            if (filter) {
                if (filter.value) {
                    filter.classList.add('border-primary');
                } else {
                    filter.classList.remove('border-primary');
                }
            }
        });
    }
}

// Initialiser quand le DOM est prêt
document.addEventListener('DOMContentLoaded', () => {
    new DocsFilter();
});

// 💾 Persistance des filtres avec localStorage
class FilterPersistence {
    static save(filters) {
        localStorage.setItem('docsFilters', JSON.stringify(filters));
    }

    static load() {
        const saved = localStorage.getItem('docsFilters');
        return saved ? JSON.parse(saved) : {};
    }

    static clear() {
        localStorage.removeItem('docsFilters');
    }
}