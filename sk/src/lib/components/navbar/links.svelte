<script lang="ts">
    import { resetMode, setMode } from 'mode-watcher';
    import * as DropdownMenu from '$lib/components/ui/dropdown-menu/index';
    import Sun from 'svelte-radix/Sun.svelte';
    import Moon from 'svelte-radix/Moon.svelte';
    import Button from "../ui/button/button.svelte";
    import Links from './links.svelte';
    import Avatar from "../avatar/Avatar.svelte";
    import { currentUser, pb } from '../../pocketbase/pocketbase';
    import { isDialogOpen } from '$lib/stores/isDialogOpen';
    import { get, writable } from 'svelte/store';
    import { onMount } from 'svelte';
    import { onDestroy } from 'svelte';
    let record = null;
    let error = null;
    let fullName = '';
    let avatarPath = '';
    
    // Create writable stores to hold fullName and avatarPath
    const userFullName = writable('');
    const userAvatarPath = writable('');

    // Subscribe to currentUser changes
    const unsubscribe = currentUser.subscribe(async (user) => {
        const userId = user?.id;
        
        if (userId) {
            try {
                record = await pb.collection('users').getOne(userId, {
                    expand: 'relField1,relField2.subRelField',
                });
                fullName = record.name;
                avatarPath = pb.files.getUrl(record, record.avatar, { 'thumb': '35x35' });
                
                // Update writable stores
                userFullName.set(fullName);
                userAvatarPath.set(avatarPath);
            } catch (err) {
                error = err;
                console.error('Error fetching user record:', error);
            }
        } else {
            console.warn('No user ID found');
            userFullName.set(''); // Reset if no user
            userAvatarPath.set(''); // Reset if no user
        }
    });

    // Clean up subscription on component destroy
    onDestroy(() => {
        unsubscribe();
    });
</script>

<!-- <a href="#" class="block text-foreground hover:text-primary transition-colors">Home</a>
<a href="#" class="block text-foreground hover:text-primary transition-colors">About</a>
<a href="#" class="block text-foreground hover:text-primary transition-colors">Services</a>
<a href="#" class="block text-foreground hover:text-primary transition-colors">Contact</a> -->

<DropdownMenu.Root>
    <DropdownMenu.Trigger asChild let:builder>
        <Button builders={[builder]} variant="outline" size="icon">
            <Sun class="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
            <Moon class="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
            <span class="sr-only">Toggle theme</span>
        </Button>
    </DropdownMenu.Trigger>
    <DropdownMenu.Content align="end">
        <DropdownMenu.Item on:click={() => setMode('light')}>Light</DropdownMenu.Item>
        <DropdownMenu.Item on:click={() => setMode('dark')}>Dark</DropdownMenu.Item>
        <DropdownMenu.Item on:click={() => resetMode()}>System</DropdownMenu.Item>
    </DropdownMenu.Content>
</DropdownMenu.Root>

<DropdownMenu.Root>
    <DropdownMenu.Trigger asChild let:builder>
        <Button builders={[builder]} variant="outline" class="bg-transparent border-none p-0">
            {#if $currentUser}
                <Avatar name={$userFullName} src={$userAvatarPath} />
            {:else}
                <img src="/emptypfp.svg" />
            {/if}
        </Button>
    </DropdownMenu.Trigger>
    <DropdownMenu.Content class="w-56">
        <DropdownMenu.Label>My Account</DropdownMenu.Label>
        <DropdownMenu.Separator />
        {#if $currentUser}
            <DropdownMenu.Item on:click={() => pb.authStore.clear()}>
                Log out
            </DropdownMenu.Item>
        {:else}
            <DropdownMenu.Item on:click={() => isDialogOpen.set(true)}>
                Log In
            </DropdownMenu.Item>
        {/if}
    </DropdownMenu.Content>
</DropdownMenu.Root>
