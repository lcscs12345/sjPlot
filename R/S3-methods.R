#' @importFrom utils browseURL
#' @export
print.sjTable <- function(x, ...) {
  if (x$show) {

    # check if we have filename specified
    if (!is.null(x$file)) {
      # write file
      write(x$knitr, file = x$file)
    } else {
      # else open in viewer pane
      htmlFile <- tempfile(fileext = ".html")
      write(x$page.complete, file = htmlFile)
      # check whether we have RStudio Viewer
      viewer <- getOption("viewer")
      if (x$viewer && !is.null(viewer)) {
        viewer(htmlFile)
      } else {
        utils::browseURL(htmlFile)
      }
    }
  }
}


#' @importFrom knitr knit_print asis_output
#' @export
knit_print.sjTable <-  function(input, ...) {
  knitr::asis_output(input$knitr, ...)
}


# knitr method for grpmean() ----

#' @export
knit_print.sjt_grpmean <-  function(input, ...) {
  knitr::asis_output(pgrpmean(input, ...)$knitr)
}

#' @export
knit_print.sjt_grpmeans <-  function(input, ...) {
  knitr::asis_output(pgrpmeans(input, ...)$knitr)
}


# knitr method method for reliab_test() ----

#' @export
knit_print.sjt_reliab <-  function(input, ...) {
  knitr::asis_output(preliab(input, ...)$knitr)
}


# knitr method method for descr() ----

#' @export
knit_print.sjt_descr <-  function(input, ...) {
  knitr::asis_output(pdescr(input, ...)$knitr)
}

#' @export
knit_print.sjt_grpdescr <-  function(input, ...) {
  knitr::asis_output(pgdescr(input, ...)$knitr)
}


# knitr method for frq() ----

#' @export
knit_print.sjt_frq <-  function(input, ...) {
  knitr::asis_output(pfrq(input, ...)$knitr)
}


# knitr method for mwu() ----

#' @export
knit_print.sjt_mwu <-  function(input, ...) {
  knitr::asis_output(pmwu(input, ...)$knitr)
}


# HTMl table method for grpmean() ----

#' @export
print.sjt_grpmean <- function(x, ...) {
  print(pgrpmean(x, ...), ...)
}

#' @export
print.sjt_grpmeans <- function(x, ...) {
  print(pgrpmeans(x, ...), ...)
}


# HTMl table method for reliab_test() ----

#' @export
print.sjt_reliab <- function(x, ...) {
  print(preliab(x, ...), ...)
}


# HTMl table method for descr() ----

#' @export
print.sjt_descr <- function(x, ...) {
  print(pdescr(x, ...), ...)
}

#' @export
print.sjt_grpdescr <- function(x, ...) {
  print(pgdescr(x, ...), ...)
}


# HTMl table method for frq() ----

#' @export
print.sjt_frq <- function(x, ...) {
  print(pfrq(x, ...), ...)
}


# HTMl table method for mwu() ----

#' @export
print.sjt_mwu <- function(x, ...) {
  print(pmwu(x, ...), ...)
}



pgrpmean <- function(x, ...) {
  title <- sprintf(
    "Mean for %s by %s",
    attr(x, "dv.label", exact = TRUE),
    attr(x, "grp.label", exact = TRUE)
  )

  footnote <- sprintf(
    "Anova: R<sup>2</sup>=%.3f; adj.R<sup>2</sup>=%.3f; F=%.3f; p=%.3f",
    attr(x, "r2", exact = TRUE),
    attr(x, "adj.r2", exact = TRUE),
    attr(x, "fstat", exact = TRUE),
    attr(x, "p.value", exact = TRUE)
  )

  tab_df(
    x = x,
    title = title,
    footnote = footnote,
    col.header = NULL,
    show.type = FALSE,
    show.rownames = FALSE,
    show.footnote = TRUE,
    alternate.rows = FALSE,
    encoding = "UTF-8",
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-top:1px solid; border-bottom: double;'
    ),
    file = NULL,
    use.viewer = attr(x, "print", exact = TRUE) == "viewer",
    ...
  )
}


#' @importFrom purrr map_chr
pgrpmeans <- function(x, ...) {
  uv <- attr(x, "print", exact = TRUE) == "viewer"

  titles <- purrr::map_chr(x, ~ sprintf(
    "Mean for %s by %s<br><span class=\"subtitle\">grouped by %s</span>",
    attr(.x, "dv.label", exact = TRUE),
    attr(.x, "grp.label", exact = TRUE),
    gsub(pattern = "\n", replacement = "<br>", attr(.x, "group", exact = TRUE), fixed = T)
  ))

  footnotes <- purrr::map_chr(x, ~ sprintf(
    "Anova: R<sup>2</sup>=%.3f; adj.R<sup>2</sup>=%.3f; F=%.3f; p=%.3f",
    attr(.x, "r2", exact = TRUE),
    attr(.x, "adj.r2", exact = TRUE),
    attr(.x, "fstat", exact = TRUE),
    attr(.x, "p.value", exact = TRUE)
  ))


  tab_dfs(
    x = x,
    titles = titles,
    footnotes = footnotes,
    col.header = NULL,
    show.type = FALSE,
    show.rownames = FALSE,
    show.footnote = TRUE,
    alternate.rows = FALSE,
    encoding = "UTF-8",
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-top:1px solid; border-bottom: double;'
    ),
    file = NULL,
    use.viewer = uv,
    ...
  )
}


preliab <- function(x, ...) {
  chead <- c(
    "Variable",
    "&alpha; if deleted",
    "Item Discrimination"
  )

  tab_df(
    x = x,
    title = "Reliability Test",
    footnote = NULL,
    col.header = chead,
    show.type = FALSE,
    show.rownames = FALSE,
    show.footnote = FALSE,
    alternate.rows = FALSE,
    encoding = "UTF-8",
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-bottom: 1px solid;'
    ),
    file = NULL,
    use.viewer = attr(x, "print", exact = TRUE) == "viewer",
    ...
  )
}


#' @importFrom purrr map_if
#' @importFrom tibble as_tibble
#' @importFrom sjmisc is_float
pdescr <- function(x, ...) {
  digits <- 2

  # do we have digits argument?
  add.args <- lapply(match.call(expand.dots = F)$`...`, function(x) x)
  if ("digits" %in% names(add.args)) digits <- eval(add.args[["digits"]])

  uv <- attr(x, "print", exact = TRUE) == "viewer"

  chead <- c(
    "Variable",
    "Type",
    "Label",
    "N",
    "Missings (%)",
    "Mean",
    "SD",
    "SE",
    "Median",
    "Trimmed Mean",
    "Min",
    "Max",
    "Range",
    "Skewness",
    "Kurtosis"
  )


  x <- x %>%
    purrr::map_if(sjmisc::is_float, ~ round(.x, digits)) %>%
    tibble::as_tibble()

  tab_df(
    x = x,
    title = "Basic descriptive statistics",
    footnote = NULL,
    col.header = chead,
    show.type = FALSE,
    show.rownames = FALSE,
    show.footnote = FALSE,
    alternate.rows = TRUE,
    encoding = "UTF-8",
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-bottom: 1px solid;'
    ),
    file = NULL,
    use.viewer = uv,
    ...
  )
}


#' @importFrom purrr map_if map_chr map
#' @importFrom tibble as_tibble
#' @importFrom sjmisc is_float
pgdescr <- function(x, ...) {
  titles <- purrr::map_chr(x, ~ sprintf(
    "Basic descriptives<br><span class=\"subtitle\"><em>grouped by</em> %s</span>",
    gsub(pattern = "\n", replacement = "<br>", attr(.x, "group", exact = TRUE), fixed = T)
  ))

  digits <- 2

  # do we have digits argument?
  add.args <- lapply(match.call(expand.dots = F)$`...`, function(x) x)
  if ("digits" %in% names(add.args)) digits <- eval(add.args[["digits"]])

  uv <- attr(x, "print", exact = TRUE) == "viewer"

  chead <- c(
    "Variable",
    "Type",
    "Label",
    "N",
    "Missings (%)",
    "Mean",
    "SD",
    "SE",
    "Median",
    "Trimmed Mean",
    "Min",
    "Max",
    "Range",
    "Skewness",
    "Kurtosis"
  )

  x <- x %>%
    purrr::map(~ purrr::map_if(
      .x,
      sjmisc::is_float,
      ~ round(.x, digits)
    ) %>% tibble::as_tibble())

  tab_dfs(
    x = x,
    titles = titles,
    footnotes = NULL,
    col.header = chead,
    show.type = FALSE,
    show.rownames = FALSE,
    show.footnote = FALSE,
    alternate.rows = TRUE,
    encoding = "UTF-8",
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-bottom: 1px solid;'
    ),
    file = NULL,
    use.viewer = uv,
    ...
  )
}


#' @importFrom purrr map_if map_chr map
#' @importFrom tibble as_tibble
#' @importFrom dplyr n_distinct select
pfrq <- function(x, ...) {
  uv <- attr(x, "print", exact = TRUE) == "viewer"

  titles <- purrr::map_chr(x, function(i) {

    ret <- ""

    # get variable label
    lab <- attr(i, "label", exact = T)
    vt <- attr(i, "vartype", exact = T)

    if (!is.null(lab)) ret <- sprintf("%s <span style=\"font-weight: normal; font-style: italic\">&lt;%s&gt</span>", lab, vt)

    # get grouping title label
    grp <- attr(i, "group", exact = T)

    if (!is.null(grp))
      ret <- sprintf("%s<br><span class=\"subtitle\"><em>grouped by:</em><br>%s</span>", ret, grp)

    gsub(pattern = "\n", replacement = "<br>", x = ret, fixed = T)
  })


  footnotes <- purrr::map_chr(x, ~ sprintf(
    "total N=%i &middot; valid N=%i &middot; x&#772=%.2f &middot; &sigma;=%.2f\n",
    sum(.x$frq, na.rm = TRUE),
    sum(.x$frq[1:(nrow(.x) - 1)], na.rm = TRUE),
    attr(.x, "mean", exact = T),
    attr(.x, "sd", exact = T)
  )
  )


  x <- purrr::map(x, function(i) {
    if (dplyr::n_distinct(i$label) == 1 && unique(i$label) == "<none>")
      i <- dplyr::select(i, -.data$label)
    i
  })


  tab_dfs(
    x = x,
    titles = titles,
    footnotes = footnotes,
    col.header = NULL,
    show.type = FALSE,
    show.rownames = FALSE,
    show.footnote = TRUE,
    alternate.rows = FALSE,
    encoding = "UTF-8",
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-bottom: 1px solid;',
      css.col2 = 'text-align: left;',
      css.col3 = 'text-align: right;',
      css.col4 = 'text-align: right;',
      css.col5 = 'text-align: right;',
      css.col6 = 'text-align: right;'
    ),
    file = NULL,
    use.viewer = uv,
    ...
  )
}


#' @importFrom stats na.omit kruskal.test
pmwu <- function(x, ...) {
  fn <- NULL

  chead <- c(
    "Groups",
    "N",
    "Mean Rank",
    "Mann-Whitney U",
    "Wilcoxon W",
    "Z",
    "Effect Size",
    "p-value"
  )

  # if we have more than 2 groups, also perfom kruskal-wallis-test
  if (length(unique(stats::na.omit(x$data$grp))) > 2) {

    kw <- stats::kruskal.test(x$data$x, x$data$grp)

    if (kw$p.value < 0.001) {
      p  <- 0.001
      p.string <- "<"
    } else {
      p <- kw$p.value
      p.string <- "="
    }

    fn <-
      sprintf(
        "Kruskal-Wallis-Test: &chi;<sup>2</sup>=%.3f &middot; df=%i &middot; p%s%.3f",
        kw$statistic,
        kw$parameter,
        p.string,
        p
      )
  }


  tab_df(
    x = x$tab.df,
    title = "Mann-Whitney U-Test",
    footnote = fn,
    col.header = chead,
    show.rownames = FALSE,
    show.type = FALSE,
    show.footnote = !is.null(fn),
    alternate.rows = TRUE,
    file = NULL,
    CSS = list(
      css.firsttablecol = '+text-align:left;',
      css.lasttablerow = 'border-bottom: 1px solid;'
    ),
    use.viewer = attr(x, "print", exact = TRUE) == "viewer",
    ...
  )
}
