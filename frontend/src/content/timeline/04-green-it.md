---
year: "2024"
title: "Le Challenge des 5 Watts"
description: "Prise de conscience de l'impact énergétique. Optimisation radicale du code et de l'infra pour faire tourner 10 services sur un matériel minimaliste."
icon: "leaf"
category: "philosophy"
lesson: "La contrainte matérielle pousse à écrire un meilleur code."
link: "/labo"
linkText: "Explorer le Labo"
---

**Question déclencheur :** Combien mon serveur consomme-t-il réellement ?  
**Réponse mesurée :** ~45W en idle pour servir quelques pages web. Inacceptable.

### Actions menées

**Remplacement des images Docker lourdes**
- Ubuntu → Alpine Linux (-60% RAM)
- Node.js → Build statique Astro (adieu au serveur JS)

**Optimisation du code**
- Lazy loading des images, cache Nginx agressif, minification des assets

**Changement de matériel**
- Mini-PC basse consommation pour certains services

### Résultat final

- **Consommation : ~8W en charge** (objectif 5W presque atteint)
- 10 services Docker actifs
- Temps de réponse < 100ms

**Philosophie acquise :** Green IT n'est pas une mode, c'est une responsabilité technique.

  <section class="timeline-section">
    <div class="timeline-container">
      <!-- Header -->
      <div class="timeline-header">
        <h1>🗺️ L'Évolution Technique</h1>
        <p class="intro">
          De Linux débutant à profil DevOps orienté Green IT. 
          Voici les <strong>déclics</strong> qui ont forgé mes compétences.
        </p>
      </div>

      <!-- Timeline verticale -->
      <div class="timeline-wrapper">
        {renderedTimeline.map((item, index) => (
          <article class="timeline-item" data-category={item.data.category}>
            {/* Année + Icône */}
            <div class="timeline-marker">
              <div 
                class="marker-dot" 
                style={`background: ${categoryColors[item.data.category as keyof typeof categoryColors]}`}
              >
                <span class="category-icon">
                  {categoryIcons[item.data.category as keyof typeof categoryIcons]}
                </span>
              </div>
              <span class="year">{item.data.year}</span>
            </div>

            {/* Contenu */}
            <div class="timeline-content">
              <div class="content-header">
                <h2>{item.data.title}</h2>
                <span 
                  class="category-badge"
                  style={`background: ${categoryColors[item.data.category as keyof typeof categoryColors]}`}
                >
                  {item.data.category}
                </span>
              </div>
              
              <p class="description">{item.data.description}</p>

              {/* Contenu Markdown détaillé */}
              <div class="markdown-content prose">
                <item.Content />
              </div>

              {/* Leçon apprise */}
              <div class="lesson-box">
                <span class="lesson-icon">💡</span>
                <p class="lesson-text"><em>{item.data.lesson}</em></p>
              </div>

              {/* Lien interne si présent */}
              {item.data.link && (
                <a href={item.data.link} class="internal-link">
                  {item.data.linkText || 'En savoir plus'} →
                </a>
              )}
            </div>
          </article>
        ))}
      </div>
    </div>
  </section>
</Layout>

<style>
  .timeline-section {
    min-height: 100vh;
    background: var(--bg-primary);
    padding: var(--spacing-xl) var(--spacing-md);
  }

  .timeline-container {
    max-width: 1000px;
    margin: 0 auto;
  }

  .timeline-header {
    text-align: center;
    margin-bottom: var(--spacing-xl);
  }

  .timeline-header h1 {
    font-size: 3rem;
    margin-bottom: var(--spacing-md);
  }

  .intro {
    font-size: 1.1rem;
    color: var(--text-secondary);
    line-height: 1.6;
    max-width: 700px;
    margin: 0 auto;
  }

  .intro strong {
    color: var(--accent-color);
  }

  /* Timeline verticale */
  .timeline-wrapper {
    position: relative;
    padding-left: 80px;
  }

  /* Ligne verticale centrale */
  .timeline-wrapper::before {
    content: '';
    position: absolute;
    left: 40px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: linear-gradient(
      to bottom,
      #3b82f6,
      #f59e0b,
      #06b6d4,
      #10b981,
      #8b5cf6
    );
  }

  /* Item de timeline */
  .timeline-item {
    position: relative;
    margin-bottom: var(--spacing-xl);
    display: flex;
    gap: var(--spacing-lg);
  }

  /* Marker (année + dot) */
  .timeline-marker {
    position: absolute;
    left: -80px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: var(--spacing-xs);
  }

  .marker-dot {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    border: 4px solid var(--bg-primary);
    position: relative;
    z-index: 2;
  }

  .category-icon {
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
  }

  .year {
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--accent-color);
    background: var(--bg-secondary);
    padding: 0.3rem 0.6rem;
    border-radius: var(--radius-sm);
    white-space: nowrap;
  }

  /* Contenu */
  .timeline-content {
    background: var(--bg-secondary);
    border-radius: var(--radius-lg);
    padding: var(--spacing-lg);
    border: 1px solid var(--border-color);
    flex: 1;
    transition: transform var(--transition-normal), box-shadow var(--transition-normal);
  }

  .timeline-content:hover {
    transform: translateX(5px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  }

  .content-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: var(--spacing-md);
    gap: var(--spacing-md);
  }

  .content-header h2 {
    font-size: 1.8rem;
    margin: 0;
    color: var(--text-primary);
  }

  .category-badge {
    padding: 0.3rem 0.7rem;
    border-radius: var(--radius-full);
    font-size: 0.75rem;
    font-weight: 600;
    color: white;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    white-space: nowrap;
  }

  .description {
    font-size: 1.05rem;
    color: var(--text-secondary);
    margin-bottom: var(--spacing-md);
    line-height: 1.6;
  }

  /* Contenu Markdown */
  .markdown-content {
    font-size: 0.95rem;
    line-height: 1.8;
    color: var(--text-primary);
    margin-bottom: var(--spacing-md);
  }

  .prose :global(h2),
  .prose :global(h3) {
    color: var(--accent-color);
    margin-top: var(--spacing-md);
    margin-bottom: var(--spacing-sm);
  }

  .prose :global(strong) {
    color: var(--accent-color);
    font-weight: 600;
  }

  .prose :global(ul) {
    margin: var(--spacing-sm) 0;
    padding-left: var(--spacing-lg);
  }

  .prose :global(li) {
    margin: var(--spacing-xs) 0;
  }

  .prose :global(code) {
    background: var(--bg-accent);
    padding: 0.2rem 0.4rem;
    border-radius: var(--radius-sm);
    font-size: 0.9em;
    color: var(--accent-color);
  }

  /* Leçon apprise */
  .lesson-box {
    background: var(--bg-accent);
    border-left: 4px solid var(--accent-color);
    padding: var(--spacing-md);
    border-radius: var(--radius-md);
    margin: var(--spacing-md) 0;
    display: flex;
    align-items: flex-start;
    gap: var(--spacing-sm);
  }

  .lesson-icon {
    font-size: 1.5rem;
    flex-shrink: 0;
  }

  .lesson-text {
    margin: 0;
    color: var(--text-secondary);
    font-size: 0.95rem;
    line-height: 1.6;
  }

  .lesson-text em {
    font-style: italic;
    color: var(--text-primary);
  }

  /* Lien interne */
  .internal-link {
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
    color: var(--accent-color);
    text-decoration: none;
    font-weight: 600;
    font-size: 0.95rem;
    margin-top: var(--spacing-sm);
    transition: all var(--transition-fast);
  }

  .internal-link:hover {
    gap: 0.6rem;
    text-decoration: underline;
  }

  /* Responsive */
  @media (max-width: 768px) {
    .timeline-header h1 {
      font-size: 2rem;
    }

    .timeline-wrapper {
      padding-left: 60px;
    }

    .timeline-wrapper::before {
      left: 30px;
    }

    .timeline-marker {
      left: -60px;
    }

    .marker-dot {
      width: 50px;
      height: 50px;
      font-size: 1.5rem;
    }

    .content-header {
      flex-direction: column;
      align-items: flex-start;
    }

    .content-header h2 {
      font-size: 1.4rem;
    }

    .timeline-content {
      padding: var(--spacing-md);
    }
  }

  @media (max-width: 480px) {
    .timeline-wrapper {
      padding-left: 40px;
    }

    .timeline-wrapper::before {
      left: 20px;
    }

    .timeline-marker {
      left: -40px;
    }

    .marker-dot {
      width: 40px;
      height: 40px;
      font-size: 1.2rem;
    }

    .year {
      font-size: 0.75rem;
      padding: 0.2rem 0.4rem;
    }
  }
</style>
