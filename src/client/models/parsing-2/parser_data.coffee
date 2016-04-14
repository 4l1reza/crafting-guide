#
# Crafting Guide - parser_data.coffee
#
# Copyright © 2014-2016 by Redwood Labs
# All rights reserved.
#

########################################################################################################################

module.exports = class ParserData

    constructor: ->
        @clear()

        @_toAssemble = []
        @_toBuild = []
        @_toValidate = []

    # Public Methods ###############################################################################

    addError: (command, message)->
        if not command? then throw new Error 'command is required'
        message ?= 'is not valid'
        @_errors.push command:command, message:message

    create: (command, type, id=null)->
        id ?= _.uniqueId "#{type}-"

        typeData = @_findOrCreateType type
        itemData = @_current = typeData['current'] = typeData[id] = id:id, command:command, type:type

        @_toAssemble.push itemData
        @_toBuild.push itemData
        @_toValidate.push itemData

        return itemData

    clear: ->
        @_current = null
        @_data = {}
        @_errors = []

    get: (type, id)->
        typeData = @_findOrCreateType type
        itemData = typeData[id] or null
        return itemData

    getCurrent: (type)->
        return @_current unless type?

        typeData = @_findOrCreateType type
        current = typeData['current'] or null
        return current

    popNextToAssemble: ->
        return @_toAssemble.pop() or null

    popNextToBuild: ->
        return @_toBuild.pop() or null

    popNextToValidate: ->
        return @_toValidate.pop() or null

    # Property Methods #############################################################################

    getErrors: ->
        return @_errors[..]

    getIsAssembled: ->
        return @_toAssemble.length > 0

    getIsBuilt: ->
        return @_toBuild.length > 0

    getIsValidated: ->
        return @_toValidate.length > 0

    Object.defineProperties @prototype,
        errors:      { get:@::getErrors      }
        isAssembled: { get:@::getIsAssembled }
        isBuilt:     { get:@::getIsBuilt     }
        isValidated: { get:@::getIsValidated }


    # Private Methods ##############################################################################

    _findOrCreateType: (type)->
        typeData = @_data[type]
        if not typeData?
            typeData = @_data[type] = {}
            typeData.type = type

        return typeData
