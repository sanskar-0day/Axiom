<script>
  import { Icon } from '@axiom/ui'
  import { currentRoute, navigate } from '../lib/router'

  const navItems = [
    { route: 'packages', icon: 'package', label: 'Packages' },
    { route: 'options', icon: 'settings', label: 'Options' },
    { route: 'graph', icon: 'graph', label: 'Graph' },
    { route: 'terminal', icon: 'terminal', label: 'Terminal' },
    { route: 'settings', icon: 'settings', label: 'Settings' },
  ]
</script>

<aside class="sidebar">
  <div class="sidebar-header">
    <h1 class="logo">Axiom</h1>
  </div>

  <nav class="sidebar-nav">
    {#each navItems as item}
      <button
        class="nav-item"
        class:active={$currentRoute === item.route}
        on:click={() => navigate(item.route)}
      >
        <Icon name={item.icon} size={20} />
        <span>{item.label}</span>
      </button>
    {/each}
  </nav>
</aside>

<style>
  .sidebar {
    width: var(--sidebar-width);
    height: 100vh;
    background: var(--color-bg-1);
    border-right: 1px solid var(--color-border);
    display: flex;
    flex-direction: column;
    flex-shrink: 0;
  }

  .sidebar-header {
    padding: var(--space-5) var(--space-5);
    border-bottom: 1px solid var(--color-border);
  }

  .logo {
    font-size: var(--text-xl);
    font-weight: 700;
    color: var(--color-primary);
    letter-spacing: 0.05em;
  }

  .sidebar-nav {
    padding: var(--space-3);
    display: flex;
    flex-direction: column;
    gap: var(--space-1);
  }

  .nav-item {
    display: flex;
    align-items: center;
    gap: var(--space-3);
    padding: var(--space-2) var(--space-3);
    background: transparent;
    border: none;
    border-radius: var(--radius-md);
    color: var(--color-text-secondary);
    font-size: var(--text-sm);
    text-align: left;
    transition: all var(--transition-fast);
    width: 100%;
  }

  .nav-item:hover {
    background: var(--color-bg-2);
    color: var(--color-text-primary);
  }

  .nav-item.active {
    background: var(--color-primary-subtle);
    color: var(--color-primary);
  }
</style>
