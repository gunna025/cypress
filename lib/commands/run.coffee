_       = require("lodash")
path    = require("path")
chalk   = require("chalk")
install = require("./install")
utils   = require("../utils")

run = (options) ->
  opts = {}
  args = ["--project", options.project]

  ## if key is set use that - else attempt to find it by env var
  options.key ?= process.env.CYPRESS_RECORD_KEY or process.env.CYPRESS_CI_KEY

  if options.env
    args.push("--env", options.env)

  if options.config
    args.push("--config", options.config)

  if options.port
    args.push("--port", options.port)

  ## if we have a specific spec push that into the args
  if options.spec
    args.push("--spec", options.spec)

  ## if we have a specific reporter push that into the args
  if options.reporter
    args.push("--reporter", options.reporter)

  ## if we have a specific reporter push that into the args
  if options.reporterOptions
    args.push("--reporter-options", options.reporterOptions)

  if options.noRecord
    args.push("--no-record")

  ## if we have a key assume we're in record mode
  if options.key
    args.push("--key", options.key)
    opts.xvfb = true

  utils.spawn(args, opts)

module.exports = {
  start: (project = ".", options = {}) ->
    _.defaults options,
      key:             null
      spec:            null
      reporter:        null
      reporterOptions: null
      project:         path.resolve(process.cwd(), project)

    @run(options)

  run: (options) ->
    after = ->
      run(options)

    utils.verifyCypressExists()
    .then(after)
    .catch ->
      console.log("")
      console.log("Cypress was not found:", chalk.green("Installing a fresh copy."))
      console.log("")

      ## TODO: no reason after should be a callback function here
      ## just use a promise
      install.start({after: after, displayOpen: false})


}
