% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sample-pars.R
\name{sample_normals}
\alias{sample_normals}
\title{Sample from normal distributions}
\usage{
sample_normals(n, mean, sd, col_names = NULL)
}
\arguments{
\item{n}{Number of observations.}

\item{mean}{Vector of means.}

\item{sd}{Vector of stadnard deviations.}

\item{col_names}{Column names to returned matrix.}
}
\value{
Matrix with each column a sample from a normal distribution.
}
\description{
Sample from multiple independent normal distributions. Produces a unique sample of size \code{n} using each element in 
\code{mean} and \code{sd}. Equivalent to sampling from a multivariate normal distribution with no covariance. Each sample using \code{rnorm}.
}
