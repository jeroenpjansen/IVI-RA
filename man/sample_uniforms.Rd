% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sample-pars.R
\name{sample_uniforms}
\alias{sample_uniforms}
\title{Sample from uniform distributions}
\usage{
sample_uniforms(n, lower, upper, col_names = NULL)
}
\arguments{
\item{n}{Number of observations.}

\item{lower}{Vector of lower bounds.}

\item{upper}{Vector of upper bounds.}

\item{col_names}{Column names to returned matrix.}
}
\value{
Matrix with each column a sample from a uniform distribution.
}
\description{
Sample from multiple independent uniform distributions. Produces a unique sample of size \code{n} using each element in 
\code{lower} and \code{upper}. Each sample using \code{runif}.
}
