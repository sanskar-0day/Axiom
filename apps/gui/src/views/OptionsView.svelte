<script>
  import OptionTree from '../components/OptionTree.svelte'
</script>

<div class="options-view">
  <div class="options-header">
    <h2>NixOS Options</h2>
    <p>Browse and configure all NixOS options</p>
  </div>
  <OptionTree />
</div>

<style>
  .options-view {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .options-header {
    padding: var(--space-4) var(--space-4) var(--space-2);
  }

  .options-header h2 {
    font-size: var(--text-xl);
    margin-bottom: var(--space-1);
  }

  .options-header p {
    font-size: var(--text-sm);
    color: var(--color-text-secondary);
  }
</style>
