<script lang="ts">
    let {logo, value}: {logo: string, value: string} = $props();
</script>

<div class="flex items-center space-x-2 rounded-3xl border bg-muted px-3 py-1">
    <img src={logo} width="22" alt="Currency Icon" />
    <span>{value} </span>
</div>