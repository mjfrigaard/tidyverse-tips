# Tidyverse.tips blog setup

This document covers the initial setup for the https://www.tidyverse.tips/ website. It was built using [blogdown](https://bookdown.org/yihui/blogdown/) and [Hugo academic](https://themes.gohugo.io/academic/).

## Building new site

```r
blogdown::new_site(theme = "wowchemy/starter-academic")
```

This produces the following output (with two `WARN`ings)

```r
Start building sites … 
WARN 2021/01/11 15:46:12 Alert shortcode will be deprecated in future. Use Callout instead. Rename `alert` to `callout` in "post/writing-technical-content/index.md"
WARN 2021/01/11 15:46:12 Alert shortcode will be deprecated in future. Use Callout instead. Rename `alert` to `callout` in "home/demo.md"

                   | EN  
-------------------+-----
  Pages            | 88  
  Paginator pages  |  0  
  Non-page files   | 25  
  Static files     |  9  
  Processed images | 51  
  Aliases          | 21  
  Sitemaps         |  1  
  Cleaned          |  0  

Total in 2045 ms
```

After pushing to Github, the site is live (but with demo only).