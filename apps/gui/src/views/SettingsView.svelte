<script>
  import { onMount } from 'svelte'
  import { Card } from '@axiom/ui'
  import { request } from '@axiom/ws-client'
  import { systemInfo } from '@axiom/ws-client/src/stores'

  onMount(async () => {
    try {
      const info = await request('get_system_info')
      systemInfo.set(info)
    } catch (err) {
      console.error('Failed to get system info:', err)
    }
  })
</script>

<div class="settings-view">
  <h2>System Information</h2>

  {#if $systemInfo}
    <Card padding="lg">
      <div class="info-grid">
        <div class="info-item">
          <span class="label">Hostname</span>
          <span class="value">{$systemInfo.hostname}</span>
        </div>
        <div class="info-item">
          <span class="label">NixOS Version</span>
          <span class="value">{$systemInfo.nixosVersion}</span>
        </div>
        <div class="info-item">
          <span class="label">Kernel</span>
          <span class="value">{$systemInfo.kernel}</span>
        </div>
        <div class="info-item">
          <span class="label">Uptime</span>
          <span class="value">{$systemInfo.uptime}</span>
        </div>
        <div class="info-item">
          <span class="label">CPU</span>
          <span class="value">{$systemInfo.cpu}</span>
        </div>
        <div class="info-item">
          <span class="label">Memory</span>
          <span class="value">{$systemInfo.memoryUsed} / {$systemInfo.memoryTotal}</span>
        </div>
      </div>
    </Card>
  {:else}
    <p class="loading">Loading system information...</p>
  {/if}
</div>

<style>
  .settings-view {
    padding: var(--space-6);
    overflow-y: auto;
  }

  h2 {
    font-size: var(--text-xl);
    margin-bottom: var(--space-4);
  }

  .info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: var(--space-4);
  }

  .info-item {
    display: flex;
    flex-direction: column;
    gap: var(--space-1);
  }

  .label {
    font-size: var(--text-sm);
    color: var(--color-text-tertiary);
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .value {
    font-family: var(--font-mono);
    font-size: var(--text-base);
    color: var(--color-text-primary);
  }

  .loading {
    color: var(--color-text-tertiary);
  }
</style>
