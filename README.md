This reop contains a minimial working example of a containerized R Shiny application. The application demonstrates the following workflow:
 * User uploads dataset
 * Dataset is validated
 * Linear mixed model is fit using the data
 * Plot is displayed with variance components and 95% CIs
 * A report (.html) can be downloaded (it only contains the plot for demo purposes)

Additionally, this is intended to show how to isolate reactive/frontend Shiny-specific code from the non-reactive/backend R modeling and plotting code. This follows a fundamental design principle of "orthogonality", whereby the backend logic and front end reactivity
