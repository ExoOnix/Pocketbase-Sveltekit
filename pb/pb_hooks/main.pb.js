
routerAdd("GET", "/health-check", (c) => {

    return c.json(200, { "message": "All good." })
})
