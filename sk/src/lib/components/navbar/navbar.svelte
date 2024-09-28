<script lang="ts">
  import Button from "../ui/button/button.svelte";
  import Links from './links.svelte'
  let isMobileMenuOpen = false;

  function toggleMobileMenu() {
    isMobileMenuOpen = !isMobileMenuOpen;
  }
</script>

<body class="bg-background text-foreground">
  <header class="bg-background border-b border-border">
    <nav class="container mx-auto px-4">
      <div class="flex items-center justify-between h-16">
        <div class="flex items-center">
          <a href="#" class="text-xl font-bold text-primary">Logo</a>
        </div>
        <div class="hidden md:flex items-center space-x-4">
          <Links />
        </div>
        <div class="md:hidden">
          <Button on:click={toggleMobileMenu}>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          </Button>
        </div>
      </div>
      {#if isMobileMenuOpen}
        <div class="md:hidden py-4 flex flex-col items-center space-y-2">
          <Links />
        </div>
      {/if}
    </nav>
  </header>
</body>