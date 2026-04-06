<script>
  import { Input, Icon } from '@axiom/ui'
  import { request } from '@axiom/ws-client'
  import { searchResults, searchQuery } from '@axiom/ws-client/src/stores'

  let searchTimeout = null

  function onInput() {
    if (searchTimeout) clearTimeout(searchTimeout)
    searchTimeout = setTimeout(async () => {
      if ($searchQuery.length < 2) {
        searchResults.set([])
        return
      }
      try {
        const results = await request('search_packages', { query: $searchQuery })
        searchResults.set(results)
      } catch (err) {
        console.error('Search failed:', err)
      }
    }, 200)
  }
</script>

<div class="search-wrapper">
  <Icon name="search" size={18} />
  <Input
    type="search"
    placeholder="Search packages..."
    size="lg"
    bind:value={$searchQuery}
    on:input={onInput}
  />
</div>

<style>
  .search-wrapper {
    display: flex;
    align-items: center;
    gap: var(--space-3);
    padding: var(--space-4);
    border-bottom: 1px solid var(--color-border);
  }

  .search-wrapper :global(.input) {
    border: none;
    background: transparent;
    font-size: var(--text-lg);
  }

  .search-wrapper :global(.input:focus) {
    box-shadow: none;
  }
</style>
