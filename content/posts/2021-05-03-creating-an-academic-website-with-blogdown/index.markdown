---
title: Creating an academic website with blogdown
author: Martin Frigaard
date: '2021-05-03'
slug: []
categories:
  - blogdown
tags: []
draft: yes
---


# Overview

I recently created a website in [RStudio](https://rstudio.com/) with [blogdown](https://bookdown.org/yihui/blogdown/) using the [Hugo academic theme](https://themes.gohugo.io/academic/) and [Netlify](https://www.netlify.com/). 

Dan Quintana created a [great post on this last year with VS Code](https://www.dsquintana.blog/), so I thought I'd create on for 2021 in RStudio. If you're looking for instructions on how to setup a basic blogdown site (not academic), you can check out the post I wrote on [Storybench.](https://www.storybench.org/how-to-build-a-website-with-blogdown-in-r/) 

Read more about the academic theme in the [documentation](https://wowchemy.com/docs/getting-started/install/). 


## 1) Getting started 

All of these steps were done using R, RStudio, GitHub, and Netlify.

- Technology requirements:  
  - [ ] Download and install [RStudio](https://rstudio.com/)  
  - [ ] Download and install [R](https://cran.r-project.org/)  
  - [ ] Create a [Netlify](https://www.netlify.com/) account  
  - [ ] Create a [GitHub](https://github.com) account.  

You can optionally purchase a domain through a service like [Google Domains](https://domains.google/). Feel free to read more about domain registration [here in the `blogdown` book](https://bookdown.org/yihui/blogdown/domain-name.html).  





***

## 2) Installing the `blogdown` package 

Run the following code to install `blogdown` (also make sure you have Hugo installed). 

```r
install.packages("blogdown”)
library(blogdown) 
blogdown::install_hugo(force = TRUE)
```

After running `blogdown::install_hugo(force = TRUE)`, you might need to update the version of Hugo in your `.Rprofile`.

```r
The latest Hugo version is v0.82.0
------------------------------------------------------------------------
You have set the option 'blogdown.hugo.version' to '0.80.0' (perhaps in 
.Rprofile), but you are installing the Hugo version '0.82.0' now. You may
want to update the option 'blogdown.hugo.version' accordingly.
-----------------------------------------------------------------------
trying URL 'https://github.com/gohugoio/hugo/releases/download/v0.82.0/
hugo_extended_0.82.0_macOS-64bit.tar.gz'
Content type 'application/octet-stream' length 15013690 bytes (14.3 MB)
==================================================
downloaded 14.3 MB

Hugo has been installed to "/Users/mjfrigaard/Library/Application
Support/Hugo/0.82.0".
```

The .Rprofile file should automatically open, and we can change this on the following line, 

```r
# fix Hugo version
options(blogdown.hugo.version = "0.82.0")
```

***

## 3) Creating a new website with `blogdown` in RStudio

Enter the following lines of code in the **Console**

```r
blogdown::new_site(dir = "~/Documents/example-academic", 
                   install_hugo = TRUE, 
                   theme = "wowchemy/starter-academic")
```

You will see the following output: 

```r
― Creating your new site
| Installing the theme wowchemy/starter-academic from github.com
trying URL 'https://github.com/wowchemy/starter-academic/archive/master.tar.gz'
downloaded 7.3 MB

trying URL 'https://github.com/wowchemy/wowchemy-hugo-modules/archive/17505c4581cd.tar.gz'
downloaded 520 KB

| Adding the sample post to ~/example-academic/content/post/2020-12-01-r-rmarkdown/index.en.Rmd
| Converting all metadata to the YAML format
| Adding netlify.toml in case you want to deploy the site to Netlify
● [TODO] The file 'netlify.toml' exists, and I will not overwrite it. 
  If you want to overwrite it, you may call blogdown::config_netlify() 
  by yourself.
| Adding .Rprofile to set options() for blogdown
― The new site is ready
○ To start a local preview: use blogdown::serve_site(), or the RStudio
  add-in "Serve Site"
○ To stop a local preview: use blogdown::stop_server(), or restart 
  your R session
► Want to serve and preview the site now? (y/n)
```

We are impatient and want to see this thing, so we enter `y`

```r
► Want to serve and preview the site now? (y/n) y
```

And voila! Our new site!

![](https://i.imgur.com/RTBoQuR.png)

*if your RStudio IDE doesn't look as cool as mine, consider installing the [rsthemes](https://www.garrickadenbuie.com/project/rsthemes/) package from the embassador of all things cool, [Garrick Aden‑Buie](https://www.garrickadenbuie.com/)*

***



## 4) Building vs. serving the new site 

There are two commands to use when building a new website:  [`blogdown::build_site()`](https://pkgs.rstudio.com/blogdown/reference/build_site.html) and [`blogdown::serve_site()`](https://pkgs.rstudio.com/blogdown/reference/serve_site.html)

### 4.1) `blogdown::build_site()`

The first, `blogdown::build_site()`, will rebuild your website locally. See the example below:

![](https://i.imgur.com/85dkP6v.png)

### 4.2) `blogdown::serve_site()`

The second command, `blogdown::serve_site()` will allow us to preview a local version of our website. 

![](https://i.imgur.com/qQRZ0eg.png)

When we makes changes, we will use the combination of `blogdown::build_site()` and `blogdown::serve_site()` to deploy our site to Netlify. You can read more about this workflow in the [blogdown book](https://bookdown.org/yihui/blogdown/workflow.html), but the gist of it is that all the website's files are created in the `public/` folder when we build and serve our site, and then when we push the changes to GitHub, Netlify deploys our new site: 

```bash
git add -A 
git commit -m "updates"
git push
```

There is a more in-depth summary of this process on the [deployment chapter of the blogdown book](https://bookdown.org/yihui/blogdown/deployment.html#deployment), too. 


*** 

# Making changes 

The next sections will cover how to make changes to the content of your academic site. As you can see from the preview, the demo site comes with a ton of example content, so most of the changes can be done to these existing files. Other changes will involve creating new files, or removing the example files and folders. 


## 5) Changing the title of your website

The name of this website is `martinfrigaard.io`, which I will change the first three lines in the `config.yaml` file:

```yaml
theme: starter-academic
title: Martin Frigaard dot io
baseurl: 'https://www.martinfrigaard.io/'
```

I can check this with another call to `blogdown::serve_site()`. 

![](https://i.imgur.com/V78y3Ze.png)

Great! So far, so good!


***

## 6) Changing the colors 


The `config/_default/params.toml` file contains the colors settings for your blog. 

```toml 
############################
## Theme
############################
# Choose a theme.
#   Latest themes (may require updating): 
#     https://sourcethemes.com/academic/themes/
#   Browse built-in themes in `themes/academic/data/themes/`
#   Browse user installed themes in `data/themes/`
theme = "mr robot"
```

#### Error alert!

After setting the `theme` to `mr robot`, I rebuild and serve the site, and I get the following warning: 

```toml 
Start building sites … 
WARN 2021/03/20 11:43:48 Alert shortcode will be deprecated in future. 
Use Callout instead. Rename `alert` to `callout` in 
"post/writing-technical-content/index.md"
WARN 2021/03/20 11:43:48 Alert shortcode will be deprecated in future. 
Use Callout instead. Rename `alert` to `callout` in "home/demo.md"
```

![](https://i.imgur.com/czDSC2q.jpg)

After changing all the `alert`s to `callout`s in the `index.md` and `demo.md` files, we no longer see the warning.


## 7) Changing the `hero` widget

Next we will change the `hero` widget. We can do this by going into `content/home/hero.md` and changing `active = true` to `active = false`

```markdown
# Hero widget.
widget = "hero"  # See https://sourcethemes.com/academic/docs/page-builder/
headless = true  # This file represents a page section.
active = false  # Activate this widget? true/false
weight = 10  # Order that this section will appear.
```

![](https://i.imgur.com/IvfKP3Y.jpg)

## 8) Updating Profile Photo


I am going to change the profile photo using a local image file (a headshot my mother approves of :))

I'll move it in `content/authors/admin` as `avatar.jpg`. After rebuilding, I see the following: 

![](https://i.imgur.com/4tSueK9.png)

*But wait, that's not my name!!!*

## 9) Editing Biography

I navigate to the `content/authors/admin/_index.md` file and edit the relevant content. 

After rebuilding and serving, the site looks like this: 

![](https://i.imgur.com/ecfgdfg.png)

## 10) Editing Contact Details


To edit the contact details, I used the same `config/\\_default/params.toml` file I did previously, but this time I changed the `Contact details` section:

```toml
# Enter contact details (optional). To hide a field, clear it to "".
email = "mjfrigaard@pm.me"
phone = "503 333 0531"

# Address
# For country_code, use the 2-letter ISO code 
# (see https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 )
address = {street = "2034 S Paseo Loma Circle", city = "Mesa", region = "AZ",..}

# Geographic coordinates
# To get your coordinates, right-click on Google Maps and choose "What's here?".
# The coords will show up at the bottom.
coordinates = {latitude = "", longitude = ""}

# Directions for visitors to locate you.
directions = ""

# Office hours
# A list of your office hours. To remove, set to an empty list `[]`.
office_hours = []

# Enter an optional link for booking appointments (e.g. calendly.com).
appointment_url = "https://calendly.com/mfrigaard"

# Contact links
#   Set to `[]` to disable, or comment out unwanted lines with a hash `#`.
contact_links = [
  {icon = "twitter", icon_pack = "fab", name = "DM Me", link = "https://twitter.com/mjfrigaard"},
  ]
```

When I rebuild and serve the site, I see the following:

![](https://i.imgur.com/dCH1Hc4.png)


## 11) Removing Demo

I want to remove the demo from the landing page. I can do this by going to `content/home/demo.md` and changing `active: true` to `active: false`

```markdown
# Activate this widget? true/false
active: false
```

Build, serve, and I see: 

![](https://i.imgur.com/NyRHgFG.png)

I can see there is a `Demo` option listed on the header, which we can remove with by editing the `config/_default/menus.toml` file: 

```toml
[[main]] 
  name = "Demo"
  url = "#hero"
  weight = 10
```

I commented this out and added a note 

```toml
# [[main]] -> demo.md was set to `active: false`
#  name = "Demo"
#  url = "#hero"
#  weight = 10
```

Build, serve, and I see:

![](https://i.imgur.com/wgwXnNi.png)

The `Demo` item has been removed from the header!

## 12) Editing Experience 

The experience section is located in `content/home/experience.md`. The details on how to add/change this content is provided below:

```markdown
# Experiences.
#   Add/remove as many `experience` items below as you like.
#   Required fields are `title`, `company`, and `date_start`.
#   Leave `date_end` empty if it's your current employer.
#   Begin multi-line descriptions with YAML's `|2-` multi-line prefix.
```

Each experience is listed under `experience:` and has the following information: 

```markdown 
experience:
  - title: Senior Clinical Programmer
    company: BioMarin
    company_url: https://www.biomarin.com/
    location: California
    date_start: '2020-10-01'
    date_end: ''
    description: |2-
        Responsibilities include:
        * Centralized statistical monitoring (CSM)
        * Shiny app development 
        * Natural language processing
```

When I rebuild and serve the site, I see the following: 

![](https://i.imgur.com/qM1ifOk.png)

#### 12.1) Adding your CV as a pdf

This is as simple as putting a .pdf of my CV in the `static/media/` folder

# More details

Because the academic theme is constantly changing, I've tried to capture as much as possible in [this HackMD file](https://hackmd.io/@mfrigaard/HJrcTTbV_), and I will continue updating this as I make changes to my site. Feel free to leave a comment or question! 

