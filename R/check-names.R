check_names_df <- function(j, ...) UseMethod("check_names_df")

#' @export
check_names_df.default <- function(j, ...) {
  stopc("Unsupported index type: ", class(j)[[1L]])
}

#' @export
check_names_df.character <- function(j, x) {
  check_needs_no_dim(j)

  pos <- safe_match(j, names(x))
  if(anyNA(pos)) {
    unknown_names <- j[is.na(pos)]
    stopc(pluralise_msg("Unknown column(s): ", unknown_names))
  }
  pos
}

#' @export
check_names_df.numeric <- function(j, x) {
  check_needs_no_dim(j)

  if (anyNA(j)) {
    stopc("NA column indexes not supported")
  }

  non_integer <- (j != trunc(j))
  if (any(non_integer)) {
    stopc(pluralise_msg("Invalid non-integer column index(es): ", j[non_integer]))
  }
  neg_too_small <- (j < -length(x))
  if (any(neg_too_small)) {
    stopc(pluralise_msg("Invalid negative column index(es): ", j[neg_too_small]))
  }
  pos_too_large <- (j > length(x))
  if (any(pos_too_large)) {
    stopc(pluralise_msg("Invalid column index(es): ", j[pos_too_large]))
  }

  seq_along(x)[j]
}

#' @export
check_names_df.logical <- function(j, x) {
  check_needs_no_dim(j)

  if (!(length(j) %in% c(1L, length(x)))) {
    stopc("Length of logical index vector must be 1 or ", length(x), ", got: ", length(j))
  }
  if (anyNA(j)) {
    stopc("NA column indexes not supported")
  }
  seq_along(x)[j]
}

check_needs_no_dim <- function(j) {
  if (needs_dim(j)) {
    stopc("Unsupported use of matrix or array for column indexing")
  }
}

# check_names_before_after ------------------------------------------------

check_names_before_after <- function(j, ...) UseMethod("check_names_before_after")

#' @export
check_names_before_after.default <- function(j, ...) {
  j
}

#' @export
check_names_before_after.character <- function(j, names) {
  check_needs_no_dim(j)

  pos <- safe_match(j, names)
  if(anyNA(pos)) {
    unknown_names <- j[is.na(pos)]
    stopc(pluralise_msg("Unknown column(s): ", unknown_names))
  }
  pos
}
