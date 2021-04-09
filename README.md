Tidyverse Tips
========


## Dark mode 

This feature is controlled by the `dark.js` file found in 

```bash
themes/lekh/static/js
└── dark.js
```

I've set the mode to 'light' in the following function (i.e. `prefers-color-scheme:dark` to `prefers-color-scheme:light`)

```js
function setMode(modeOption) {
    GWLog("setMode");

    // Inject the appropriate styles.
    let modeStyles = document.querySelector("#mode-styles");
    if (modeOption == 'auto') {
        modeStyles.innerHTML = `@media (prefers-color-scheme:light) {${GW.modeStyles}}`;
    } else if (modeOption == 'dark') {
        modeStyles.innerHTML = GW.modeStyles;
    } else {
        modeStyles.innerHTML = "";
    }

    // Update selector state.
    updateModeSelectorState();
}

```