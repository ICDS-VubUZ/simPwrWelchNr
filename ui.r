# shiny in and output
# input in sidebar, including action button
# output in main panel, including information and plot
ui <- fluidPage(

	titlePanel("Simulating Power Welch Corrected One Way for Balanced Low Sample Sizes"),

	sidebarLayout(

		sidebarPanel(
			fluidRow(
				textInput('avs', 'averages per group (semicolon delimited, eg., 28.6;10; 5.72)', ""),
				textInput('sds', 'standard deviations per group (semicolon delimited, eg., 7;3;1.4)', ""),
				textInput('bnd', 'lower and upper boundary of group size (semicolon delimited, eg., 3;8)', ""),
				textInput('ssz', 'number of simulations (eg., 10000)', "10")
			),
			tags$a(href="manual.pdf", "open introduction in new window", target="new"),
			h5("Susanne Blotwijk: simulation algorithm"),
			h6("https://www.icds.be  (Wilfried Cools: shiny suit)"),
			hr(),
			h5("interpretation"),
			img(src='ToolOutput.png',width='100%'),
			br(),
			br(),
			h5("diagnostics"),
			img(src='MoreSimulationsNeeded.png',width='100%'),
			width=4
		),

		mainPanel(
			actionButton("simulate", "SIMULATE the power for given group statistics"),
			br(),
			br(),
			tableOutput("setup"),
			width=8
		)

	)
)