# shiny functionality
# retrieve input when changed
# provide output using functions inside
server <- function(input, output) {

	getInput <- reactive({
		out <- list()
		validate(
			need(input$avs, 'specify ; delimited means'),
			need(input$sds, 'specify ; delimited standard deviations'),
			need(input$bnd, 'specify ; delimited lower and upper boundaries'),
			need(input$ssz, 'specify number of simulations')
		)
		.avs <- as.numeric(unlist(gsub(" ","",unlist(strsplit(input$avs,";")))))
		.sds <- as.numeric(unlist(gsub(" ","",unlist(strsplit(input$sds,";")))))
		.bnd <- as.numeric(unlist(gsub(" ","",unlist(strsplit(input$bnd,";")))))
		.ssz <- as.numeric(input$ssz)
		validate(
			need(length(.avs==.sds),'the number of averages and standard deviations must match the number of groups')
		)
		# t1e
		out <- list(avs=.avs,sds=.sds,bnd=.bnd,ssz=.ssz)
		out
	})
	processInput <- reactive({
		myinput <- getInput()
		means <- myinput$avs # c(28.6, 10, 5.72)
		sds <- myinput$sds # c(7,3,1.4)
		lowerbound2 <- 3#myinput$bnd[1] # 3 
		upperbound2 <- 8#myinput$bnd[2] # 8
		simsize <- myinput$ssz # 10^3

		pooledSD <- mean(sds^2)^0.5

		power2 <- vector(length=(upperbound2+1-lowerbound2))
		for(n2 in lowerbound2:upperbound2){
		  j  <- n2-lowerbound2+1
		  y <- rep(seq(length(means)), n2)
		  power2[j] <- sum(replicate(simsize, oneway.test(x~y, data.frame(x=rnorm(n2*length(means), sds),y))$p.value<0.05))/simsize
		}
		tmp <- data.frame(nr=lowerbound2:upperbound2,power=power2)
		tmp
	})
	# add button
	simtF <- eventReactive(input$simulate, {
		# out <- processInput()
		out <- processInput()
		out
	}, ignoreNULL = TRUE)
	output$setup <- renderTable({
		out <- simtF()
		out
	})
}
