<script>
  import { Button } from '@axiom/ui'
  import { request, on, off } from '@axiom/ws-client'
  import { installedPackages, rebuildProgress } from '@axiom/ws-client/src/stores'

  export let pkg

  let installing = false

  $: isInstalled = $installedPackages.includes(pkg.name)

  async function install() {
    installing = true
    const handler = (msg) => {
      if (msg.type === 'progress') {
        rebuildProgress.set({
          active: true,
          percent: msg.percent,
          message: msg.message,
          lines: [...($rebuildProgress?.lines || []), msg.message]
        })
      }
    }
    on('progress', handler)

    try {
      await request('install_package', { name: pkg.name })
      installedPackages.update(pkgs => [...pkgs, pkg.name])
      rebuildProgress.set({ active: false, percent: 100, message: 'Done', lines: [] })
    } catch (err) {
      console.error('Install failed:', err)
    } finally {
      installing = false
      off('progress', handler)
    }
  }
</script>

<div class="package-card">
  <div class="info">
    <div class="name-row">
      <span class="name">{pkg.name}</span>
      <span class="version">{pkg.version}</span>
    </div>
    <p class="description">{pkg.description}</p>
  </div>
  <div class="actions">
    {#if isInstalled}
      <Button variant="ghost" size="sm" disabled>Installed</Button>
    {:else}
      <Button size="sm" loading={installing} on:click={install}>
        Install
      </Button>
    {/if}
  </div>
</div>

<style>
  .package-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: var(--space-3) var(--space-4);
    border-bottom: 1px solid var(--color-border);
    transition: background var(--transition-fast);
  }

  .package-card:hover {
    background: var(--color-bg-2);
  }

  .name {
    font-weight: 600;
    color: var(--color-text-primary);
  }

  .version {
    font-size: var(--text-xs);
    color: var(--color-text-tertiary);
    margin-left: var(--space-2);
  }

  .description {
    font-size: var(--text-sm);
    color: var(--color-text-secondary);
    margin-top: var(--space-1);
  }
</style>
