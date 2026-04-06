<script>
  import { searchResults } from '@axiom/ws-client/src/stores'
  import PackageSearch from '../components/PackageSearch.svelte'
  import PackageCard from '../components/PackageCard.svelte'
</script>

<div class="packages-view">
  <PackageSearch />
  <div class="results-list">
    {#each $searchResults as pkg (pkg.name)}
      <PackageCard {pkg} />
    {:else}
      <div class="empty-state">
        <p>Search for packages to install</p>
        <p class="hint">Try "firefox", "git", or "python3"</p>
      </div>
    {/each}
  </div>
</div>

<style>
  .packages-view {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .results-list {
    flex: 1;
    overflow-y: auto;
  }

  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: var(--color-text-tertiary);
    gap: var(--space-2);
  }

  .hint {
    font-size: var(--text-sm);
  }
</style>
