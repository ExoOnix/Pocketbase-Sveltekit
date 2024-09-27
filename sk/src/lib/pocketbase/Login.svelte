<script lang="ts">
    import {currentUser, pb} from './pocketbase'
    import Button from '$lib/components/ui/button/button.svelte';
    import Input from '$lib/components/ui/input/input.svelte';
    import * as Card from "$lib/components/ui/card";
    import Label from '$lib/components/ui/label/label.svelte';
    import * as Tabs from "$lib/components/ui/tabs/index.js";

    let username: string
    let password: string
    let confirmpassword: string
    let email: string

    async function login() {
        await pb.collection('users').authWithPassword(username, password)
    }

    async function signUp() {
        try {
            const data = {
                email: email,
                username,
                password,
                passwordConfirm: confirmpassword,
            }
            const createdUser = await pb.collection('users').create(data)
            await login()
        } catch (error) {
            console.log(error)
        }
    }
    function signOut() {
        pb.authStore.clear()
    }
</script>

<style>
    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999; /* High z-index to ensure it's on top */
    }

    .card {
        z-index: 10000; /* Ensure card itself is on top */
    }
</style>

{#if $currentUser}
<p>
    Signed in as {$currentUser.username}
    <Button on:click={signOut}>Sign Out</Button>
</p>
{:else}
<div class="overlay">
  <Card.Root class="w-auto p-4 card">
    <Card.Header>
      <Card.Title>Authentication</Card.Title>
      <Card.Description>Login or create a new account.</Card.Description>
    </Card.Header>
    <Card.Content>
      <Tabs.Root value="login" class="w-[400px]">
        <Tabs.List class="grid w-full grid-cols-2">
          <Tabs.Trigger value="login">Log In</Tabs.Trigger>
          <Tabs.Trigger value="signUp">Sign Up</Tabs.Trigger>
        </Tabs.List>
        <Tabs.Content value="login">
          <form on:submit|preventDefault>
            <div class="grid w-full items-center gap-4">
              <div class="flex flex-col space-y-1.5">
                <Label for="Username">Username or Email</Label>
                <Input id="username" placeholder="Your Username or Email" type="text" bind:value={username} />
              </div>
              <div class="flex flex-col space-y-1.5">
                <Label for="Password">Password</Label>
                <Input id="password" placeholder="Your Password" type="password" bind:value={password} />
              </div>
            </div>
          </form>
          <Button on:click={login} class="mt-3">Login</Button>
        </Tabs.Content>
        <Tabs.Content value="signUp">
          <form on:submit|preventDefault>
            <div class="grid w-full items-center gap-4">
            <div class="flex flex-col space-y-1.5">
                <Label for="Email">Email</Label>
                <Input id="email" placeholder="Your Email" type="email" bind:value={email} />
              </div>
              <div class="flex flex-col space-y-1.5">
                <Label for="Username">Username</Label>
                <Input id="username" placeholder="Your Username" type="text" bind:value={username} />
              </div>
              <div class="flex flex-col space-y-1.5">
                <Label for="Password">Password</Label>
                <Input id="password" placeholder="Your Password" type="password" bind:value={password} />
              </div>
                <div class="flex flex-col space-y-1.5">
                <Label for="ConfirmPassword">Confirm Password</Label>
                <Input id="confirmpassword" placeholder="Confirm Your Password" type="password" bind:value={confirmpassword} />
              </div>
            </div>
          </form>
          <Button on:click={signUp} class="mt-3">Sign Up</Button>
        </Tabs.Content>
      </Tabs.Root>
    </Card.Content>
  </Card.Root>
</div>
{/if}
