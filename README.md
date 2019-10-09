tidyverse tips
==============

This is a blog for various `tidyverse` tips from around the web. I try to update
this blog everyday, but that's not always possible. 


## Blog structure and theme  

This blog was build using the `blogdown` package. The
[Hugo Terminal](https://github.com/panr/hugo-theme-terminal/) theme was written
by Radek Kozie. More information on this is below: 

The theme includes:

- **5 duotone themes**, depending on your preferences (orange, red, blue, green, pink)
- [**Fira Code**](https://github.com/tonsky/FiraCode) as default monospaced font. It's gorgeous!
- **realy nice, custom duotone** syntax highlighting based on [**PrismJS**](https://prismjs.com)
- mobile friendly layout

### Set up 

The initial setup was configured with Github using the following commands in 
the Terminal:

```bash
git remote add origin https://github.com/mjfrigaard/tidyverse-tips.git
git push -u origin master
```

### DNS configuration

DNS stands for [Domain Name Servers](https://en.wikipedia.org/wiki/Domain_Name_System). These help direct web traffic to your website, sort of like the phone book or yellow pages. 

We need to change the randomly generated domain name (https://random-words-blabla.netlify.com/) to the domain I’ve purchased (https://www.tidyverse.tips).

I can do this by following the instructions on the Netlify website. The image below shows the necessary parts from Netlify settings I needed to enter in the DNS settings on the Google Domains dashboard.

Anywhere it says `random-words`, you’ll enter the randomly generated domain from Netlify.

Anywhere it says `###.###.##.##`, you’ll enter the IP address for your domain.

![](figs/blogdown-google-dns-netlify-1200x985.png)

![](figs/blogdown-netlify-dns-domains-01-1200x703.png)

