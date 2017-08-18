'use strict'
var log = null
/** @const @type {!CoreObject} */
var qml = (function() {/** @const */
var exports = {};
exports._get = function(name) { return exports[name] }
/** @const */
var _globals = exports
var __prototype$ctors = []
if (!_globals.core) /** @const */ _globals.core = {}
if (!_globals.html5) /** @const */ _globals.html5 = {}
if (!_globals.html5.dist) /** @const */ _globals.html5.dist = {}
if (!_globals.src) /** @const */ _globals.src = {}
_globals.core.core = (function() {/** @const */
var exports = _globals;
exports._get = function(name) { return exports[name] }
//=====[import core.core]=====================

//WARNING: no log() function usage before init.js

exports.core.device = 0
exports.core.vendor = ""

exports.core.trace = { key: false, focus: false, listeners: false }

exports.core.os = navigator.platform
exports.core.userAgent = navigator.userAgent
exports.core.language = navigator.language

exports.core.keyCodes = {
	13: 'Select',
	27: 'Back',
	37: 'Left',
	32: 'Space',
	33: 'PageUp',
	34: 'PageDown',
	38: 'Up',
	39: 'Right',
	40: 'Down',
	48: '0',
	49: '1',
	50: '2',
	51: '3',
	52: '4',
	53: '5',
	54: '6',
	55: '7',
	56: '8',
	57: '9',
	65: 'A',
	66: 'B',
	67: 'C',
	68: 'D',
	69: 'E',
	70: 'F',
	71: 'G',
	72: 'H',
	73: 'I',
	74: 'J',
	75: 'K',
	76: 'L',
	77: 'M',
	78: 'N',
	79: 'O',
	80: 'P',
	81: 'Q',
	82: 'R',
	83: 'S',
	84: 'T',
	85: 'U',
	86: 'V',
	87: 'W',
	88: 'X',
	89: 'Y',
	90: 'Z',
	112: 'Red',
	113: 'Green',
	114: 'Yellow',
	115: 'Blue'
}

var _checkDevice = function(target, info) {
	if (navigator.userAgent.indexOf(target) < 0)
		return

	exports.core.vendor = info.vendor
	exports.core.device = info.device
	exports.core.os = info.os
}

if (!exports.core.vendor) {
	_checkDevice('Blackberry', { 'vendor': 'blackberry', 'device': 2, 'os': 'blackberry' })
	_checkDevice('Android', { 'vendor': 'google', 'device': 2, 'os': 'android' })
	_checkDevice('iPhone', { 'vendor': 'apple', 'device': 2, 'os': 'iOS' })
	_checkDevice('iPad', { 'vendor': 'apple', 'device': 2, 'os': 'iOS' })
	_checkDevice('iPod', { 'vendor': 'apple', 'device': 2, 'os': 'iOS' })
}

if (navigator.userAgent.indexOf('Chromium') >= 0)
	exports.core.browser = "Chromium"
else if (navigator.userAgent.indexOf('Chrome') >= 0)
	exports.core.browser = "Chrome"
else if (navigator.userAgent.indexOf('Opera') >= 0)
	exports.core.browser = "Opera"
else if (navigator.userAgent.indexOf('Firefox') >= 0)
	exports.core.browser = "Firefox"
else if (navigator.userAgent.indexOf('Safari') >= 0)
	exports.core.browser = "Safari"
else if (navigator.userAgent.indexOf('MSIE') >= 0)
	exports.core.browser = "IE"
else if (navigator.userAgent.indexOf('YaBrowser') >= 0)
	exports.core.browser = "Yandex"
else
	exports.core.browser = ''


_globals._backend = function() { return _globals.html5.html }


if (log === null)
	log = console.log.bind(console)

/** @const */
/** @param {string} text @param {...} args */
_globals.qsTr = function(text, args) { return _globals._context.qsTr.apply(qml._context, arguments) }

var colorTable = {
	'maroon':	'800000',
	'red':		'ff0000',
	'orange':	'ffA500',
	'yellow':	'ffff00',
	'olive':	'808000',
	'purple':	'800080',
	'fuchsia':	'ff00ff',
	'white':	'ffffff',
	'lime':		'00ff00',
	'green':	'008000',
	'navy':		'000080',
	'blue':		'0000ff',
	'aqua':		'00ffff',
	'teal':		'008080',
	'black':	'000000',
	'silver':	'c0c0c0',
	'gray':		'080808',
	'transparent': '0000'
}

var safeCallImpl = function(callback, self, args, onError) {
	try { return callback.apply(self, args) } catch(ex) { onError(ex) }
}

exports.core.safeCall = function(self, args, onError) {
	return function(callback) { return safeCallImpl(callback, self, args, onError) }
}

/**
 * @constructor
 */
var CoreObjectComponent = exports.core.CoreObject = function() { }
var CoreObjectComponentPrototype = CoreObjectComponent.prototype
CoreObjectComponentPrototype.componentName = 'core.CoreObject'
CoreObjectComponentPrototype.constructor = CoreObjectComponent
CoreObjectComponentPrototype.__create = function() { }
CoreObjectComponentPrototype.__setup = function() { }


/** @constructor */
var Color = exports.core.Color = function(value) {
	if (Array.isArray(value)) {
		this.r = value[0]
		this.g = value[1]
		this.b = value[2]
		this.a = value[3] !== undefined? value[3]: 255
		return
	}
	if (typeof value !== 'string')
	{
		this.r = this.b = this.a = 255
		this.g = 0
		log("invalid color specification: " + value)
		return
	}
	var triplet
	if (value.substring(0, 4) == "rgba") {
		var b = value.indexOf('('), e = value.lastIndexOf(')')
		value = value.substring(b + 1, e).split(',')
		this.r = parseInt(value[0], 10)
		this.g = parseInt(value[1], 10)
		this.b = parseInt(value[2], 10)
		this.a = Math.floor(parseFloat(value[3]) * 255)
		return
	}
	else {
		var h = value[0]
		if (h != '#')
			triplet = colorTable[value]
		else
			triplet = value.substring(1)
	}

	if (!triplet) {
		this.r = 255
		this.g = 0
		this.b = 255
		log("invalid color specification: " + value)
		return
	}

	var len = triplet.length;
	if (len == 3 || len == 4) {
		var r = parseInt(triplet[0], 16)
		var g = parseInt(triplet[1], 16)
		var b = parseInt(triplet[2], 16)
		var a = (len == 4)? parseInt(triplet[3], 16): 15
		this.r = (r << 4) | r;
		this.g = (g << 4) | g;
		this.b = (b << 4) | b;
		this.a = (a << 4) | a;
	} else if (len == 6 || len == 8) {
		this.r = parseInt(triplet.substring(0, 2), 16)
		this.g = parseInt(triplet.substring(2, 4), 16)
		this.b = parseInt(triplet.substring(4, 6), 16)
		this.a = (len == 8)? parseInt(triplet.substring(6, 8), 16): 255
	} else
		throw new Error("invalid color specification: " + value)
}
var ColorPrototype = Color.prototype
ColorPrototype.constructor = exports.core.Color
/** @const */

ColorPrototype.rgba = function() {
	return "rgba(" + this.r + "," + this.g + "," + this.b + "," + (this.a / 255) + ")";
}

var hexByte = function(v) {
	return ('0' + (Number(v).toString(16))).slice(-2)
}

ColorPrototype.hex = function() {
	return '#' + hexByte(this.r) + hexByte(this.g) + hexByte(this.b) + hexByte(this.a)
}

exports.core.normalizeColor = function(spec) {
	return (new Color(spec)).rgba()
}

exports.core.mixColor = function(specA, specB, r) {
	var a = new Color(specA)
	var b = new Color(specB)
	var mix = function(a, b, r) { return Math.floor((b - a) * r + a) }
	return [mix(a.r, b.r, r), mix(a.g, b.g, r), mix(a.b, b.b, r), mix(a.a, b.a, r)]
}

exports.addLazyProperty = function(proto, name, creator) {
	var storageName = '__lazy_property_' + name
	var forwardName = '__forward_' + name

	var get = function(object) {
		var value = object[storageName]
		if (value !== undefined)
			return value
		else
			return (object[storageName] = creator(object))
	}

	Object.defineProperty(proto, name, {
		get: function() {
			return get(this)
		},

		set: function(newValue) {
			var forwardedTarget = this[forwardName]
			if (forwardedTarget !== undefined) {
				var target = get(this)
				if (target !== null && (target instanceof Object)) {
					//forward property update for mixins
					var forwardedValue = target[forwardedTarget]
					if (newValue !== forwardedValue) {
						target[forwardedTarget] = newValue
						this._update(name, newValue, forwardedValue)
					}
					return
				}
			}

			throw new Error('setting attempt on readonly lazy property ' + name + ' in ' + proto.componentName)
		},
		enumerable: true
	})
}

exports.addProperty = function(proto, type, name, defaultValue) {
	var convert
	switch(type) {
		case 'enum':
		case 'int':		convert = function(value) { return ~~value }; break
		case 'bool':	convert = function(value) { return value? true: false }; break
		case 'real':	convert = function(value) { return +value }; break
		case 'string':	convert = function(value) { return String(value) }; break
		default:		convert = function(value) { return value }; break
	}

	if (defaultValue !== undefined) {
		defaultValue = convert(defaultValue)
	} else {
		switch(type) {
			case 'enum': //fixme: add default value here
			case 'int':		defaultValue = 0; break
			case 'bool':	defaultValue = false; break
			case 'real':	defaultValue = 0.0; break
			case 'string':	defaultValue = ""; break
			case 'array':	defaultValue = []; break
			case 'Color':	defaultValue = '#0000'; break
			default:
				defaultValue = (type[0].toUpperCase() == type[0])? null: undefined
		}
	}

	var storageName = '__property_' + name
	var forwardName = '__forward_' + name

	Object.defineProperty(proto, name, {
		get: function() {
			var p = this[storageName]
			return p !== undefined?
				p.interpolatedValue !== undefined? p.interpolatedValue: p.value:
				defaultValue
		},

		set: function(newValue) {
			newValue = convert(newValue)
			var p = this[storageName]
			if (p === undefined) { //no storage
				if (newValue === defaultValue) //value == defaultValue, no storage allocation
					return

				p = this[storageName] = { value : defaultValue }
			}

			var animation = this.getAnimation(name)
			if (animation && p.value !== newValue) {
				var backend = this._context.backend
				if (p.frameRequest)
					backend.cancelAnimationFrame(p.frameRequest)

				p.started = Date.now()

				var src = p.interpolatedValue !== undefined? p.interpolatedValue: p.value
				var dst = newValue

				var self = this

				var complete = function() {
					backend.cancelAnimationFrame(p.frameRequest)
					p.frameRequest = undefined
					animation.complete = function() { }
					animation.running = false
					p.interpolatedValue = undefined
					p.started = undefined
					self._update(name, dst, src)
				}

				var duration = animation.duration

				var nextFrame = function() {
					var now = Date.now()
					var t = 1.0 * (now - p.started) / duration
					if (t >= 1) {
						complete()
					} else {
						p.interpolatedValue = convert(animation.interpolate(dst, src, t))
						self._update(name, p.interpolatedValue, src)
						p.frameRequest = backend.requestAnimationFrame(nextFrame)
					}
				}

				p.frameRequest = backend.requestAnimationFrame(nextFrame)

				animation.running = true
				animation.complete = complete
			}
			var oldValue = p.value
			if (oldValue !== newValue) {
				var forwardTarget = this[forwardName]
				if (forwardTarget !== undefined) {
					if (oldValue !== null && (oldValue instanceof Object)) {
						//forward property update for mixins
						var forwardedOldValue = oldValue[forwardTarget]
						if (newValue !== forwardedOldValue) {
							oldValue[forwardTarget] = newValue
							this._update(name, newValue, forwardedOldValue)
						}
						return
					} else if (newValue instanceof Object) {
						//first assignment of mixin
						this.connectOnChanged(newValue, forwardTarget, function(v, ov) { this._update(name, v, ov) }.bind(this))
					}
				}
				p.value = newValue
				if ((!animation || !animation.running) && newValue === defaultValue)
					delete this[storageName]
				if (!animation)
					this._update(name, newValue, oldValue)
			}
		},
		enumerable: true
	})
}

exports.addAliasProperty = function(self, name, getObject, srcProperty) {
	var target = getObject()
	self.connectOnChanged(target, srcProperty, function(value) { self._update(name, value) })

	Object.defineProperty(self, name, {
		get: function() { return target[srcProperty] },
		set: function(value) { target[srcProperty] = value },
		enumerable: true
	})
}

exports.core.createSignal = function(name) {
	return function() {
		this.emitWithArgs(name, arguments)
	}
}
exports.core.createSignalForwarder = function(object, name) {
	return (function() {
		object.emitWithArgs(name, arguments)
	})
}

/** @constructor */
exports.core.EventBinder = function(target) {
	this.target = target
	this.callbacks = {}
	this.enabled = false
}

exports.core.EventBinder.prototype.on = function(event, callback) {
	if (event in this.callbacks)
		throw new Error('double adding of event (' + event + ')')
	this.callbacks[event] = callback
	if (this.enabled)
		this.target.on(event, callback)
}

exports.core.EventBinder.prototype.constructor = exports.core.EventBinder

exports.core.EventBinder.prototype.enable = function(value) {
	if (value != this.enabled) {
		var target = this.target
		this.enabled = value
		if (value) {
			for(var event in this.callbacks)
				target.on(event, this.callbacks[event])
		} else {
			for(var event in this.callbacks)
				target.removeListener(event, this.callbacks[event])
		}
	}
}

var protoEvent = function(prefix, proto, name, callback) {
	var sname = '__' + prefix + '__' + name
	//if property was in base prototype, create shallow copy and put our handler there or we would add to base prototype's array
	var ownStorage = proto.hasOwnProperty(sname)
	var storage = proto[sname]
	if (storage != undefined) {
		if (ownStorage)
			storage.push(callback)
		else {
			var copy = storage.slice()
			copy.push(callback)
			proto[sname] = copy
		}
	} else
		proto[sname] = [callback]
}

exports.core._protoOn = function(proto, name, callback)
{ protoEvent('on', proto, name, callback) }

exports.core._protoOnChanged = function(proto, name, callback)
{ protoEvent('changed', proto, name, callback) }

exports.core._protoOnKey = function(proto, name, callback)
{ protoEvent('key', proto, name, callback) }

var ObjectEnumerator = function(callback) {
	this._callback = callback
	this._queue = []
	this.history = []
}

var ObjectEnumeratorPrototype = ObjectEnumerator.prototype
ObjectEnumeratorPrototype.constructor = ObjectEnumerator

ObjectEnumeratorPrototype.unshift = function() {
	var q = this._queue
	q.unshift.apply(q, arguments)
}

ObjectEnumeratorPrototype.push = function() {
	var q = this._queue
	q.push.apply(q, arguments)
}

ObjectEnumeratorPrototype.enumerate = function(root, arg) {
	var args = [this, arg]
	var queue = this._queue
	queue.unshift(root)
	while(queue.length) {
		var el = queue.shift()
		this.history.push(el)
		var r = this._callback.apply(el, args)
		if (r)
			break
	}
}

exports.forEach = function(root, callback, arg) {
	var oe = new ObjectEnumerator(callback)
	oe.enumerate(root, arg)
	return arg
}

return exports;
} )()
//========================================

/** @const @type {!CoreObject} */
var core = _globals.core.core


//=====[component core.EventEmitter]=====================

	var EventEmitterBaseComponent = _globals.core.CoreObject
	var EventEmitterBasePrototype = EventEmitterBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.CoreObject}
 */
	var EventEmitterComponent = _globals.core.EventEmitter = function(parent, _delegate) {
		EventEmitterBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._eventHandlers = {}
		this._onConnections = []
	}

	}
	var EventEmitterPrototype = EventEmitterComponent.prototype = Object.create(EventEmitterBasePrototype)

	EventEmitterPrototype.constructor = EventEmitterComponent

	EventEmitterPrototype.componentName = 'core.EventEmitter'
	EventEmitterPrototype.on = function(name,callback) {
		if (name === '')
			throw new Error('empty listener name')

		var storage = this._eventHandlers
		var handlers = storage[name]
		if (handlers !== undefined)
			handlers.push(callback)
		else {
			storage[name] = [callback]
		}
	}
	EventEmitterPrototype.discard = function() {
		for(var name in this._eventHandlers)
			this.removeAllListeners(name)
		this._onConnections.forEach(function(connection) {
			connection[0].removeListener(connection[1], connection[2])
		})
		this._onConnections = []
	}
	EventEmitterPrototype.emitWithArgs = function(name,args) {
		if (name === '')
			throw new Error('empty listener name')

		var proto_callback = this['__on__' + name]
		var handlers = this._eventHandlers[name]

		if (proto_callback === undefined && handlers === undefined)
			return

		var invoker = _globals.core.safeCall(
			this, args,
			function(ex) { log("event/signal " + name + " handler failed:", ex, ex.stack) }
		)

		if (proto_callback !== undefined)
			proto_callback.forEach(invoker)

		if (handlers !== undefined)
			handlers.forEach(invoker)
	}
	EventEmitterPrototype.connectOn = function(target,name,callback) {
		target.on(name, callback)
		this._onConnections.push([target, name, callback])
	}
	EventEmitterPrototype.removeListener = function(name,callback) {
		if (!(name in this._eventHandlers) || callback === undefined || callback === null || name === '') {
			if (_globals.core.trace.listeners)
				log('invalid removeListener(' + name + ', ' + callback + ') invocation', new Error().stack)
			return
		}

		var handlers = this._eventHandlers[name]
		var idx = handlers.indexOf(callback)
		if (idx >= 0)
			handlers.splice(idx, 1)
		else if (_globals.core.trace.listeners)
			log('failed to remove listener for', name, 'from', this)

		if (!handlers.length)
			this.removeAllListeners(name)
	}
	EventEmitterPrototype.emit = function(name) {
		if (name === '')
			throw new Error('empty listener name')

		var proto_callback = this['__on__' + name]
		var handlers = this._eventHandlers[name]

		if (proto_callback === undefined && handlers === undefined)
			return

		
		/* COPY_ARGS(args, 1) */
		var $n = arguments.length
		var args = new Array($n - 1)
		var $d = 0, $s = 1;
		while($s < $n) {
			args[$d++] = arguments[$s++]
		}


		var invoker = _globals.core.safeCall(
			this, args,
			function(ex) { log("event/signal " + name + " handler failed:", ex, ex.stack) }
		)

		if (proto_callback !== undefined)
			proto_callback.forEach(invoker)

		if (handlers !== undefined)
			handlers.forEach(invoker)
	}
	EventEmitterPrototype.removeAllListeners = function(name) {
		delete this._eventHandlers[name]
	}

//=====[component core.Object]=====================

	var ObjectBaseComponent = _globals.core.EventEmitter
	var ObjectBasePrototype = ObjectBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.EventEmitter}
 */
	var ObjectComponent = _globals.core.Object = function(parent, _delegate) {
		ObjectBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this.parent = parent
		this.children = []

		this._context = parent? parent._context: null
		this._local = {}
		if (_delegate === true)
			this._local['_delegate'] = this
		this._changedHandlers = {}
		this._changedConnections = []
		this._pressedHandlers = {}
		this._animations = {}
		this._updaters = {}
	}

	}
	var ObjectPrototype = ObjectComponent.prototype = Object.create(ObjectBasePrototype)

	ObjectPrototype.constructor = ObjectComponent

	ObjectPrototype.componentName = 'core.Object'
	ObjectPrototype.addChild = function(child) {
		this.children.push(child);
	}
	ObjectPrototype.setAnimation = function(name,animation) {
		this._animations[name] = animation;
	}
	ObjectPrototype.removeOnChanged = function(name,callback) {
		if (name in this._changedHandlers) {
			var handlers = this._changedHandlers[name];
			var idx = handlers.indexOf(callback)
			if (idx >= 0)
				handlers.splice(idx, 1)
			else
				log('failed to remove changed listener for', name, 'from', this)
		}
	}
	ObjectPrototype.connectOnChanged = function(target,name,callback) {
		target.onChanged(name, callback)
		this._changedConnections.push([target, name, callback])
	}
	ObjectPrototype.onChanged = function(name,callback) {
		var storage = this._changedHandlers
		var handlers = storage[name]
		if (handlers !== undefined)
			handlers.push(callback);
		else
			storage[name] = [callback];
	}
	ObjectPrototype.discard = function() {
		this._changedConnections.forEach(function(connection) {
			connection[0].removeOnChanged(connection[1], connection[2])
		})
		this._changedConnections = []

		this.children.forEach(function(child) { child.discard() })
		this.children = []

		this.parent = null
		this._local = {}
		this._changedHandlers = {}
		this._pressedHandlers = {}
		this._animations = {}
		//for(var name in this._updaters) //fixme: it was added once, then removed, is it needed at all? it double-deletes callbacks
		//	this._replaceUpdater(name)
		this._updaters = {}

		_globals.core.EventEmitter.prototype.discard.apply(this)
	}
	ObjectPrototype._tryFocus = function() { return false }
	ObjectPrototype._get = function(name) {
		if (name in this)
			return this[name]

		var object = this
		while(object) {
			if (name in object._local)
				return object._local[name]
			object = object.parent
		}

		throw new Error("invalid property requested: '" + name + "'")
	}
	ObjectPrototype.onPressed = function(name,callback) {
		var wrapper
		if (name != 'Key')
			wrapper = function(key, event) { event.accepted = true; callback(key, event); return event.accepted }
		else
			wrapper = callback;

		if (name in this._pressedHandlers)
			this._pressedHandlers[name].push(wrapper);
		else
			this._pressedHandlers[name] = [wrapper];
	}
	ObjectPrototype._setId = function(name) {
		var p = this;
		while(p) {
			p._local[name] = this;
			p = p.parent;
		}
	}
	ObjectPrototype._update = function(name,value) {
		var protoCallbacks = this['__changed__' + name]
		var handlers = this._changedHandlers[name]

		var hasProtoCallbacks = protoCallbacks !== undefined
		var hasHandlers = handlers !== undefined

		if (!hasProtoCallbacks && !hasHandlers)
			return

		var invoker = _globals.core.safeCall(this, [value], function(ex) { log("on " + name + " changed callback failed: ", ex, ex.stack) })

		if (hasProtoCallbacks)
			protoCallbacks.forEach(invoker)

		if (hasHandlers)
			handlers.forEach(invoker)
	}
	ObjectPrototype.getAnimation = function(name,animation) {
		var a = this._animations[name]
		return (a !== undefined && a.enabled())? a:  null;
	}
	ObjectPrototype._replaceUpdater = function(name,newUpdaters) {
		var updaters = this._updaters
		var oldUpdaters = updaters[name]
		if (oldUpdaters !== undefined) {
			oldUpdaters.forEach(function(data) {
				var object = data[0]
				var name = data[1]
				var callback = data[2]
				object.removeOnChanged(name, callback)
			})
		}

		if (newUpdaters)
			updaters[name] = newUpdaters
		else
			delete updaters[name]
	}
	ObjectPrototype._setProperty = function(name,value) {
		var storageName = '__property_' + name
		var storage = this[storageName] || {}
		delete storage.interpolatedValue
		storage.value = value
		this[storageName] = storage
	}

//=====[component core.System]=====================

	var SystemBaseComponent = _globals.core.Object
	var SystemBasePrototype = SystemBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var SystemComponent = _globals.core.System = function(parent, _delegate) {
		SystemBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		var ctx = this._context
		this.browser = _globals.core.browser
		this.userAgent = _globals.core.userAgent
		this.webkit = this.userAgent.toLowerCase().indexOf('webkit') >= 0
		this.device = _globals.core.device
		this.vendor = _globals.core.vendor
		this.os = _globals.core.os
		this.language = _globals.core.language
		ctx.language = this.language.replace('-', '_')

		this.support3dTransforms = ctx.backend.capabilities.csstransforms3d || false
		this.supportTransforms = ctx.backend.capabilities.csstransforms || false
		this.supportTransitions = ctx.backend.capabilities.csstransitions || false
	}

	}
	var SystemPrototype = SystemComponent.prototype = Object.create(SystemBasePrototype)

	SystemPrototype.constructor = SystemComponent

	SystemPrototype.componentName = 'core.System'
	SystemPrototype._updateLayoutType = function() {
		if (!this.contextWidth || !this.contextHeight)
			return
		var min = this.contextWidth;// < this.contextHeight ? this.contextWidth : this.contextHeight

		if (min <= 320)
			this.layoutType = this.MobileS
		else if (min <= 375)
			this.layoutType = this.MobileM
		else if (min <= 425)
			this.layoutType = this.MobileL
		else if (min <= 768)
			this.layoutType = this.Tablet
		else if (this.contextWidth <= 1024)
			this.layoutType = this.Laptop
		else if (this.contextWidth <= 1440)
			this.layoutType = this.LaptopL
		else
			this.layoutType = this.Laptop4K
	}
	core.addProperty(SystemPrototype, 'string', 'userAgent')
	core.addProperty(SystemPrototype, 'string', 'language')
	core.addProperty(SystemPrototype, 'string', 'browser')
	core.addProperty(SystemPrototype, 'string', 'vendor')
	core.addProperty(SystemPrototype, 'string', 'os')
	core.addProperty(SystemPrototype, 'bool', 'webkit')
	core.addProperty(SystemPrototype, 'bool', 'support3dTransforms')
	core.addProperty(SystemPrototype, 'bool', 'supportTransforms')
	core.addProperty(SystemPrototype, 'bool', 'supportTransitions')
	core.addProperty(SystemPrototype, 'bool', 'portrait')
	core.addProperty(SystemPrototype, 'bool', 'landscape')
	core.addProperty(SystemPrototype, 'bool', 'pageActive', (true))
	core.addProperty(SystemPrototype, 'int', 'screenWidth')
	core.addProperty(SystemPrototype, 'int', 'screenHeight')
	core.addProperty(SystemPrototype, 'int', 'contextWidth')
	core.addProperty(SystemPrototype, 'int', 'contextHeight')
/** @const @type {number} */
	SystemPrototype.Desktop = 0
/** @const @type {number} */
	SystemComponent.Desktop = 0
/** @const @type {number} */
	SystemPrototype.Tv = 1
/** @const @type {number} */
	SystemComponent.Tv = 1
/** @const @type {number} */
	SystemPrototype.Mobile = 2
/** @const @type {number} */
	SystemComponent.Mobile = 2
	core.addProperty(SystemPrototype, 'enum', 'device')
/** @const @type {number} */
	SystemPrototype.MobileS = 0
/** @const @type {number} */
	SystemComponent.MobileS = 0
/** @const @type {number} */
	SystemPrototype.MobileM = 1
/** @const @type {number} */
	SystemComponent.MobileM = 1
/** @const @type {number} */
	SystemPrototype.MobileL = 2
/** @const @type {number} */
	SystemComponent.MobileL = 2
/** @const @type {number} */
	SystemPrototype.Tablet = 3
/** @const @type {number} */
	SystemComponent.Tablet = 3
/** @const @type {number} */
	SystemPrototype.Laptop = 4
/** @const @type {number} */
	SystemComponent.Laptop = 4
/** @const @type {number} */
	SystemPrototype.LaptopL = 5
/** @const @type {number} */
	SystemComponent.LaptopL = 5
/** @const @type {number} */
	SystemPrototype.Laptop4K = 6
/** @const @type {number} */
	SystemComponent.Laptop4K = 6
	core.addProperty(SystemPrototype, 'enum', 'layoutType')
	_globals.core._protoOnChanged(SystemPrototype, 'contextHeight', (function(value) { this._updateLayoutType() } ))
	_globals.core._protoOnChanged(SystemPrototype, 'contextWidth', (function(value) { this._updateLayoutType() } ))

	SystemPrototype.__create = function(__closure) {
		SystemBasePrototype.__create.call(this, __closure.__base = { })

	}
	SystemPrototype.__setup = function(__closure) {
	SystemBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//assigning portrait to (this._get('parent')._get('width') < this._get('parent')._get('height'))
			var update$this$portrait = (function() { this.portrait = ((this._get('parent')._get('width') < this._get('parent')._get('height'))); }).bind(this)
			var dep$this$portrait$0 = this._get('parent')
			this.connectOnChanged(dep$this$portrait$0, 'height', update$this$portrait)
			var dep$this$portrait$1 = this._get('parent')
			this.connectOnChanged(dep$this$portrait$1, 'width', update$this$portrait)
			this._replaceUpdater('portrait', [[dep$this$portrait$0, 'height', update$this$portrait],[dep$this$portrait$1, 'width', update$this$portrait]])
			update$this$portrait();
//assigning contextWidth to (this._get('context')._get('width'))
			var update$this$contextWidth = (function() { this.contextWidth = ((this._get('context')._get('width'))); }).bind(this)
			var dep$this$contextWidth$0 = this._get('context')
			this.connectOnChanged(dep$this$contextWidth$0, 'width', update$this$contextWidth)
			this._replaceUpdater('contextWidth', [[dep$this$contextWidth$0, 'width', update$this$contextWidth]])
			update$this$contextWidth();
//assigning landscape to (! this._get('portrait'))
			var update$this$landscape = (function() { this.landscape = ((! this._get('portrait'))); }).bind(this)
			var dep$this$landscape$0 = this
			this.connectOnChanged(dep$this$landscape$0, 'portrait', update$this$landscape)
			this._replaceUpdater('landscape', [[dep$this$landscape$0, 'portrait', update$this$landscape]])
			update$this$landscape();
//assigning contextHeight to (this._get('context')._get('height'))
			var update$this$contextHeight = (function() { this.contextHeight = ((this._get('context')._get('height'))); }).bind(this)
			var dep$this$contextHeight$0 = this._get('context')
			this.connectOnChanged(dep$this$contextHeight$0, 'height', update$this$contextHeight)
			this._replaceUpdater('contextHeight', [[dep$this$contextHeight$0, 'height', update$this$contextHeight]])
			update$this$contextHeight();
}


//=====[component core.Shadow]=====================

	var ShadowBaseComponent = _globals.core.Object
	var ShadowBasePrototype = ShadowBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var ShadowComponent = _globals.core.Shadow = function(parent, _delegate) {
		ShadowBaseComponent.apply(this, arguments)

	}
	var ShadowPrototype = ShadowComponent.prototype = Object.create(ShadowBasePrototype)

	ShadowPrototype.constructor = ShadowComponent

	ShadowPrototype.componentName = 'core.Shadow'
	ShadowPrototype._getFilterStyle = function() {
		var style = this.x + "px " + this.y + "px " + this.blur + "px "
		if (this.spread > 0)
			style += this.spread + "px "
		style += _globals.core.normalizeColor(this.color)
		return style
	}
	ShadowPrototype._empty = function() {
		return !this.x && !this.y && !this.blur && !this.spread;
	}
	core.addProperty(ShadowPrototype, 'real', 'x')
	core.addProperty(ShadowPrototype, 'real', 'y')
	core.addProperty(ShadowPrototype, 'Color', 'color', ("black"))
	core.addProperty(ShadowPrototype, 'real', 'blur')
	core.addProperty(ShadowPrototype, 'real', 'spread')
	_globals.core._protoOnChanged(ShadowPrototype, 'x', (function(value) {
		this.parent._updateStyle(true)
	} ))
	_globals.core._protoOnChanged(ShadowPrototype, 'spread', (function(value) {
		this.parent._updateStyle(true)
	} ))
	_globals.core._protoOnChanged(ShadowPrototype, 'y', (function(value) {
		this.parent._updateStyle(true)
	} ))
	_globals.core._protoOnChanged(ShadowPrototype, 'blur', (function(value) {
		this.parent._updateStyle(true)
	} ))
	_globals.core._protoOnChanged(ShadowPrototype, 'color', (function(value) {
		this.parent._updateStyle(true)
	} ))

//=====[component core.Item]=====================

	var ItemBaseComponent = _globals.core.Object
	var ItemBasePrototype = ItemBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var ItemComponent = _globals.core.Item = function(parent, _delegate) {
		ItemBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._topPadding = 0
		if (parent) {
			if (this.element)
				throw new Error('double ctor call')

			this.createElement(this.getTag())
		} //no parent == top level element, skip
	}

	}
	var ItemPrototype = ItemComponent.prototype = Object.create(ItemBasePrototype)

	ItemPrototype.constructor = ItemComponent

	ItemPrototype.componentName = 'core.Item'
	ItemPrototype.boxChanged = _globals.core.createSignal('boxChanged')
	ItemPrototype.createElement = function(tag) {
		this.element = this._context.createElement(tag)
		this._context.registerStyle(this, tag)
		this.parent.element.append(this.element)
	}
	ItemPrototype.registerStyle = function(style,tag) {
		style.addRule(tag, 'position: absolute; visibility: inherit; border-style: solid; border-width: 0px; white-space: nowrap; border-radius: 0px; opacity: 1.0; transform: none; left: 0px; top: 0px; width: 0px; height: 0px;')
	}
	ItemPrototype.hasActiveFocus = function() {
		var item = this
		while(item.parent) {
			if (item.parent.focusedChild != item)
				return false

			item = item.parent
		}
		return true
	}
	ItemPrototype.invokeKeyHandlers = function(key,handlers,invoker) {
		for(var i = handlers.length - 1; i >= 0; --i) {
			var callback = handlers[i]
			if (invoker(callback)) {
				if (_globals.core.trace.key)
					log("key", key, "handled by", this, new Error().stack)
				return true;
			}
		}
		return false;
	}
	ItemPrototype._tryFocus = function() {
		if (!this.visible)
			return false

		if (this.focusedChild && this.focusedChild._tryFocus())
			return true

		var children = this.children
		for(var i = 0; i < children.length; ++i) {
			var child = children[i]
			if (child._tryFocus()) {
				this._focusChild(child)
				return true
			}
		}
		return this.focus
	}
	ItemPrototype.getTag = function() { return 'div' }
	ItemPrototype.forceActiveFocus = function() {
		var item = this;
		while(item.parent) {
			item.parent._focusChild(item);
			item = item.parent;
		}
	}
	ItemPrototype._focusTree = function(active) {
		this.activeFocus = active;
		if (this.focusedChild)
			this.focusedChild._focusTree(active);
	}
	ItemPrototype.setTransition = function(name,animation) {
		var backend = this._context.backend
		if (!backend.capabilities.csstransitions)
			return false

		var html5 = backend //remove me
		var transition = {
			property: html5.getPrefixedName('transition-property'),
			delay: html5.getPrefixedName('transition-delay'),
			duration: html5.getPrefixedName('transition-duration'),
			timing: html5.getPrefixedName('transition-timing-function')
		}

		name = html5.getPrefixedName(name) || name //replace transform: <prefix>rotate hack

		var property = this.style(transition.property) || []
		var duration = this.style(transition.duration) || []
		var timing = this.style(transition.timing) || []
		var delay = this.style(transition.delay) || []

		var idx = property.indexOf(name)
		if (idx === -1) { //if property not set
			property.push(name)
			duration.push(animation.duration + 'ms')
			timing.push(animation.easing)
			delay.push(animation.delay + 'ms')
		} else { //property already set, adjust the params
			duration[idx] = animation.duration + 'ms'
			timing[idx] = animation.easing
			delay[idx] = animation.delay + 'ms'
		}

		var style = {}
		style[transition.property] = property
		style[transition.duration] = duration
		style[transition.timing] = timing
		style[transition.delay] = delay

		//FIXME: smarttv 2003 animation is not working without this shit =(
		if (this._context.system.os === 'smartTV' || this._context.system.os === 'netcast') {
			style["transition-property"] = property
			style["transition-duration"] = duration
			style["transition-delay"] = delay
			style["transition-timing-function"] = timing
		}
		this.style(style)
		return true
	}
	ItemPrototype._focusChild = function(child) {
		if (child.parent !== this)
			throw new Error('invalid object passed as child')
		if (this.focusedChild === child)
			return
		if (this.focusedChild) {
			this.focusedChild._focusTree(false)
			this.focusedChild.focused = false
		}
		this.focusedChild = child
		if (this.focusedChild) {
			this.focusedChild._focusTree(this.hasActiveFocus())
			this.focusedChild.focused = true
		}
	}
	ItemPrototype._mapCSSAttribute = function(name) {
		return { width: 'width', height: 'height', x: 'left', y: 'top', viewX: 'left', viewY: 'top', opacity: 'opacity', border: 'border', radius: 'border-radius', rotate: 'transform', boxshadow: 'box-shadow', transform: 'transform', visible: 'visibility', visibleInView: 'visibility', background: 'background', color: 'color', font: 'font' }[name]
	}
	ItemPrototype._updateAnimation = function(name,animation) {
		if (!this._context.backend.capabilities.csstransitions || (animation && !animation.cssTransition))
			return false

		var css = this._mapCSSAttribute(name)

		if (css !== undefined) {
			if (!animation)
				throw new Error('resetting transition was not implemented')

			animation._target = name
			return this.setTransition(css, animation)
		} else {
			return false
		}
	}
	ItemPrototype.toScreen = function() {
		var item = this
		var x = 0, y = 0
		var w = this.width, h = this.height
		while(item) {
			x += item.x
			y += item.y
			if ('view' in item) {
				x += item.viewX + item.view.content.x
				y += item.viewY + item.view.content.y
			}
			item = item.parent
		}
		return [x, y, x + w, y + h, x + w / 2, y + h / 2];
	}
	ItemPrototype._updateVisibility = function() {
		var visible = this.visible && this.visibleInView

		if (this.element)
			this.style('visibility', visible? 'inherit': 'hidden')

		this.recursiveVisible = visible && (this.parent !== null? this.parent.recursiveVisible: true)
	}
	ItemPrototype.setAnimation = function(name,animation) {
		if (!this._updateAnimation(name, animation))
			_globals.core.Object.prototype.setAnimation.apply(this, arguments);
	}
	ItemPrototype.focusChild = function(child) {
		this._propagateFocusToParents()
		this._focusChild(child)
	}
	ItemPrototype._updateVisibilityForChild = function(child,value) {
		child.recursiveVisible = value && child.visible && child.visibleInView
	}
	ItemPrototype.style = function(name,style) {
		var element = this.element
		if (element)
			return element.style(name, style)
		else
			log('WARNING: style skipped:', name, style)
	}
	ItemPrototype._updateStyle = function() {
		var element = this.element
		if (element)
			element.updateStyle()
	}
	ItemPrototype.addChild = function(child) {
		_globals.core.Object.prototype.addChild.apply(this, arguments)
		if (child._tryFocus())
			child._propagateFocusToParents()
	}
	ItemPrototype._propagateFocusToParents = function() {
		var item = this;
		while(item.parent && (!item.parent.focusedChild || !item.parent.focusedChild.visible)) {
			item.parent._focusChild(item)
			item = item.parent
		}
	}
	ItemPrototype.setFocus = function() { this.forceActiveFocus() }
	ItemPrototype.discard = function() {
		_globals.core.Object.prototype.discard.apply(this)
		this.focusedChild = null
		if (this.element)
			this.element.discard()
	}
	ItemPrototype._processKey = function(event) {
		var key = _globals.core.keyCodes[event.which || event.keyCode];
		if (key) {
			//fixme: create invoker only if any of handlers exist
			var invoker = _globals.core.safeCall(this, [key, event], function (ex) { log("on " + key + " handler failed:", ex, ex.stack) })
			var proto_callback = this['__key__' + key]

			if (key in this._pressedHandlers)
				return this.invokeKeyHandlers(key, this._pressedHandlers[key], invoker)

			if (proto_callback)
				return this.invokeKeyHandlers(key, proto_callback, invoker)

			var proto_callback = this['__key__Key']
			if ('Key' in this._pressedHandlers)
				return this.invokeKeyHandlers(key, this._pressedHandlers['Key'], invoker)

			if (proto_callback)
				return this.invokeKeyHandlers(key, proto_callback, invoker)
		}
		else {
			log("unknown key", event.which);
		}
		return false;
	}
	ItemPrototype._enqueueNextChildInFocusChain = function(queue,handlers) {
		this._tryFocus() //soft-restore focus for invisible components
		var focusedChild = this.focusedChild
		if (focusedChild && focusedChild.visible) {
			queue.unshift(focusedChild)
			handlers.unshift(focusedChild)
		}
	}
	core.addProperty(ItemPrototype, 'int', 'x')
	core.addProperty(ItemPrototype, 'int', 'y')
	core.addProperty(ItemPrototype, 'int', 'z')
	core.addProperty(ItemPrototype, 'int', 'width')
	core.addProperty(ItemPrototype, 'int', 'height')
	core.addProperty(ItemPrototype, 'bool', 'clip')
	core.addProperty(ItemPrototype, 'real', 'radius')
	core.addProperty(ItemPrototype, 'bool', 'focus')
	core.addProperty(ItemPrototype, 'bool', 'focused')
	core.addProperty(ItemPrototype, 'bool', 'activeFocus')
	core.addProperty(ItemPrototype, 'Item', 'focusedChild')
	core.addProperty(ItemPrototype, 'bool', 'visible', (true))
	core.addProperty(ItemPrototype, 'bool', 'visibleInView', (true))
	core.addProperty(ItemPrototype, 'bool', 'recursiveVisible', (false))
	core.addProperty(ItemPrototype, 'real', 'opacity', (1))
	core.addLazyProperty(ItemPrototype, 'anchors', (function(__parent) {
		var lazy$anchors = new _globals.core.Anchors(__parent, true)
		var __closure = { lazy$anchors : lazy$anchors }

//creating component Anchors
			lazy$anchors.__create(__closure.__closure_lazy$anchors = { })


//setting up component Anchors
			var lazy$anchors = __closure.lazy$anchors
			lazy$anchors.__setup(__closure.__closure_lazy$anchors)
			delete __closure.__closure_lazy$anchors



		return lazy$anchors
}))
	core.addLazyProperty(ItemPrototype, 'effects', (function(__parent) {
		var lazy$effects = new _globals.core.Effects(__parent, true)
		var __closure = { lazy$effects : lazy$effects }

//creating component Effects
			lazy$effects.__create(__closure.__closure_lazy$effects = { })


//setting up component Effects
			var lazy$effects = __closure.lazy$effects
			lazy$effects.__setup(__closure.__closure_lazy$effects)
			delete __closure.__closure_lazy$effects



		return lazy$effects
}))
	core.addLazyProperty(ItemPrototype, 'transform', (function(__parent) {
		var lazy$transform = new _globals.core.Transform(__parent, true)
		var __closure = { lazy$transform : lazy$transform }

//creating component Transform
			lazy$transform.__create(__closure.__closure_lazy$transform = { })


//setting up component Transform
			var lazy$transform = __closure.lazy$transform
			lazy$transform.__setup(__closure.__closure_lazy$transform)
			delete __closure.__closure_lazy$transform



		return lazy$transform
}))
	core.addLazyProperty(ItemPrototype, 'left', (function(__parent) {
		var lazy$left = new _globals.core.AnchorLine(__parent, true)
		var __closure = { lazy$left : lazy$left }

//creating component AnchorLine
			lazy$left.__create(__closure.__closure_lazy$left = { })


//setting up component AnchorLine
			var lazy$left = __closure.lazy$left
			lazy$left.__setup(__closure.__closure_lazy$left)
			delete __closure.__closure_lazy$left

//assigning boxIndex to (0)
			lazy$left._replaceUpdater('boxIndex'); lazy$left.boxIndex = ((0));


		return lazy$left
}))
	core.addLazyProperty(ItemPrototype, 'top', (function(__parent) {
		var lazy$top = new _globals.core.AnchorLine(__parent, true)
		var __closure = { lazy$top : lazy$top }

//creating component AnchorLine
			lazy$top.__create(__closure.__closure_lazy$top = { })


//setting up component AnchorLine
			var lazy$top = __closure.lazy$top
			lazy$top.__setup(__closure.__closure_lazy$top)
			delete __closure.__closure_lazy$top

//assigning boxIndex to (1)
			lazy$top._replaceUpdater('boxIndex'); lazy$top.boxIndex = ((1));


		return lazy$top
}))
	core.addLazyProperty(ItemPrototype, 'right', (function(__parent) {
		var lazy$right = new _globals.core.AnchorLine(__parent, true)
		var __closure = { lazy$right : lazy$right }

//creating component AnchorLine
			lazy$right.__create(__closure.__closure_lazy$right = { })


//setting up component AnchorLine
			var lazy$right = __closure.lazy$right
			lazy$right.__setup(__closure.__closure_lazy$right)
			delete __closure.__closure_lazy$right

//assigning boxIndex to (2)
			lazy$right._replaceUpdater('boxIndex'); lazy$right.boxIndex = ((2));


		return lazy$right
}))
	core.addLazyProperty(ItemPrototype, 'bottom', (function(__parent) {
		var lazy$bottom = new _globals.core.AnchorLine(__parent, true)
		var __closure = { lazy$bottom : lazy$bottom }

//creating component AnchorLine
			lazy$bottom.__create(__closure.__closure_lazy$bottom = { })


//setting up component AnchorLine
			var lazy$bottom = __closure.lazy$bottom
			lazy$bottom.__setup(__closure.__closure_lazy$bottom)
			delete __closure.__closure_lazy$bottom

//assigning boxIndex to (3)
			lazy$bottom._replaceUpdater('boxIndex'); lazy$bottom.boxIndex = ((3));


		return lazy$bottom
}))
	core.addLazyProperty(ItemPrototype, 'horizontalCenter', (function(__parent) {
		var lazy$horizontalCenter = new _globals.core.AnchorLine(__parent, true)
		var __closure = { lazy$horizontalCenter : lazy$horizontalCenter }

//creating component AnchorLine
			lazy$horizontalCenter.__create(__closure.__closure_lazy$horizontalCenter = { })


//setting up component AnchorLine
			var lazy$horizontalCenter = __closure.lazy$horizontalCenter
			lazy$horizontalCenter.__setup(__closure.__closure_lazy$horizontalCenter)
			delete __closure.__closure_lazy$horizontalCenter

//assigning boxIndex to (4)
			lazy$horizontalCenter._replaceUpdater('boxIndex'); lazy$horizontalCenter.boxIndex = ((4));


		return lazy$horizontalCenter
}))
	core.addLazyProperty(ItemPrototype, 'verticalCenter', (function(__parent) {
		var lazy$verticalCenter = new _globals.core.AnchorLine(__parent, true)
		var __closure = { lazy$verticalCenter : lazy$verticalCenter }

//creating component AnchorLine
			lazy$verticalCenter.__create(__closure.__closure_lazy$verticalCenter = { })


//setting up component AnchorLine
			var lazy$verticalCenter = __closure.lazy$verticalCenter
			lazy$verticalCenter.__setup(__closure.__closure_lazy$verticalCenter)
			delete __closure.__closure_lazy$verticalCenter

//assigning boxIndex to (5)
			lazy$verticalCenter._replaceUpdater('boxIndex'); lazy$verticalCenter.boxIndex = ((5));


		return lazy$verticalCenter
}))
	core.addProperty(ItemPrototype, 'int', 'viewX')
	core.addProperty(ItemPrototype, 'int', 'viewY')
	_globals.core._protoOnChanged(ItemPrototype, 'width', (function(value) { this.style('width', value); this.boxChanged() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'z', (function(value) { this.style('z-index', value) } ))
	_globals.core._protoOnChanged(ItemPrototype, 'opacity', (function(value) { if (this.element) this.style('opacity', value); } ))
	_globals.core._protoOnChanged(ItemPrototype, 'height', (function(value) { this.style('height', value - this._topPadding); this.boxChanged() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'radius', (function(value) { this.style('border-radius', value) } ))
	_globals.core._protoOnChanged(ItemPrototype, 'x', (function(value) { var x = this.x + this.viewX; this.style('left', x); this.boxChanged() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'y', (function(value) { var y = this.y + this.viewY; this.style('top', y); this.boxChanged() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'viewY', (function(value) { var y = this.y + this.viewY; this.style('top', y); this.boxChanged() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'recursiveVisible', (function(value) {
		this.children.forEach(function(child) {
			child.recursiveVisible = value && child.visible && child.visibleInView
		})

		if (!value)
			this.parent._tryFocus()
	} ))
	_globals.core._protoOnChanged(ItemPrototype, 'viewX', (function(value) { var x = this.x + this.viewX; this.style('left', x); this.boxChanged() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'visible', (function(value) { this._updateVisibility() } ))
	_globals.core._protoOnChanged(ItemPrototype, 'clip', (function(value) { this.style('overflow', value? 'hidden': 'visible') } ))
	_globals.core._protoOnChanged(ItemPrototype, 'visibleInView', (function(value) { this._updateVisibility() } ))

//=====[component core.BaseViewContent]=====================

	var BaseViewContentBaseComponent = _globals.core.Item
	var BaseViewContentBasePrototype = BaseViewContentBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var BaseViewContentComponent = _globals.core.BaseViewContent = function(parent, _delegate) {
		BaseViewContentBaseComponent.apply(this, arguments)

	}
	var BaseViewContentPrototype = BaseViewContentComponent.prototype = Object.create(BaseViewContentBasePrototype)

	BaseViewContentPrototype.constructor = BaseViewContentComponent

	BaseViewContentPrototype.componentName = 'core.BaseViewContent'
	BaseViewContentPrototype._updateScrollPositions = function(x,y) {
		this._setProperty('x', -x)
		this._setProperty('y', -y)
		this.parent._layout()
	}
	_globals.core._protoOnChanged(BaseViewContentPrototype, 'x', (function(value) { this.parent._scheduleLayout() } ))
	_globals.core._protoOnChanged(BaseViewContentPrototype, 'y', (function(value) { this.parent._scheduleLayout() } ))

//=====[component core.Animation]=====================

	var AnimationBaseComponent = _globals.core.Object
	var AnimationBasePrototype = AnimationBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var AnimationComponent = _globals.core.Animation = function(parent, _delegate) {
		AnimationBaseComponent.apply(this, arguments)
	//custom constructor:
	{ this._disabled = 0 }

	}
	var AnimationPrototype = AnimationComponent.prototype = Object.create(AnimationBasePrototype)

	AnimationPrototype.constructor = AnimationComponent

	AnimationPrototype.componentName = 'core.Animation'
	AnimationPrototype.interpolate = function(dst,src,t) {
		return t * (dst - src) + src;
	}
	AnimationPrototype.disable = function() { ++this._disabled }
	AnimationPrototype.enabled = function() { return this._disabled == 0 }
	AnimationPrototype.complete = function() { }
	AnimationPrototype._updateAnimation = function() {
		var parent = this.parent
		if (this._target && parent && parent._updateAnimation)
			parent._updateAnimation(this._target, this.enabled() ? this: null)
	}
	AnimationPrototype.enable = function() { --this._disabled }
	core.addProperty(AnimationPrototype, 'int', 'delay', (0))
	core.addProperty(AnimationPrototype, 'int', 'duration', (200))
	core.addProperty(AnimationPrototype, 'bool', 'cssTransition', (true))
	core.addProperty(AnimationPrototype, 'bool', 'running', (false))
	core.addProperty(AnimationPrototype, 'string', 'easing', ("ease"))
	_globals.core._protoOnChanged(AnimationPrototype, 'easing', (function(value) { this._updateAnimation() } ))
	_globals.core._protoOnChanged(AnimationPrototype, 'duration', (function(value) { this._updateAnimation() } ))
	_globals.core._protoOnChanged(AnimationPrototype, 'delay', (function(value) { this._updateAnimation() } ))
	_globals.core._protoOnChanged(AnimationPrototype, 'cssTransition', (function(value) { this._updateAnimation() } ))
	_globals.core._protoOnChanged(AnimationPrototype, 'running', (function(value) { this._updateAnimation() } ))

//=====[component core.BaseLayout]=====================

	var BaseLayoutBaseComponent = _globals.core.Item
	var BaseLayoutBasePrototype = BaseLayoutBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var BaseLayoutComponent = _globals.core.BaseLayout = function(parent, _delegate) {
		BaseLayoutBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this.count = 0
	}

	}
	var BaseLayoutPrototype = BaseLayoutComponent.prototype = Object.create(BaseLayoutBasePrototype)

	BaseLayoutPrototype.constructor = BaseLayoutComponent

	BaseLayoutPrototype.componentName = 'core.BaseLayout'
	BaseLayoutPrototype._scheduleLayout = function() {
		this._context.delayedAction('layout', this, this._doLayout)
	}
	BaseLayoutPrototype._doLayout = function() {
		this._processUpdates()
		this._layout()
	}
	BaseLayoutPrototype._processUpdates = function() { }
	core.addProperty(BaseLayoutPrototype, 'int', 'count')
	core.addProperty(BaseLayoutPrototype, 'bool', 'trace')
	core.addProperty(BaseLayoutPrototype, 'int', 'spacing')
	core.addProperty(BaseLayoutPrototype, 'int', 'currentIndex')
	core.addProperty(BaseLayoutPrototype, 'int', 'contentWidth')
	core.addProperty(BaseLayoutPrototype, 'int', 'contentHeight')
	core.addProperty(BaseLayoutPrototype, 'bool', 'keyNavigationWraps')
	core.addProperty(BaseLayoutPrototype, 'bool', 'handleNavigationKeys')
	_globals.core._protoOnChanged(BaseLayoutPrototype, 'recursiveVisible', (function(value) {
		if (this.recursiveVisible)
			this._scheduleLayout()
	} ))
	_globals.core._protoOnChanged(BaseLayoutPrototype, 'spacing', (function(value) {
		if (this.recursiveVisible)
			this._scheduleLayout()
	} ))

//=====[component src.UiApp]=====================

	var UiAppBaseComponent = _globals.core.Item
	var UiAppBasePrototype = UiAppBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var UiAppComponent = _globals.src.UiApp = function(parent, _delegate) {
		UiAppBaseComponent.apply(this, arguments)

	}
	var UiAppPrototype = UiAppComponent.prototype = Object.create(UiAppBasePrototype)

	UiAppPrototype.constructor = UiAppComponent

	UiAppPrototype.componentName = 'src.UiApp'

	UiAppPrototype.__create = function(__closure) {
		UiAppBasePrototype.__create.call(this, __closure.__base = { })
var this$child0 = new _globals.core.Rectangle(this)
		__closure.this$child0 = this$child0

//creating component Rectangle
		this$child0.__create(__closure.__closure_this$child0 = { })
		var this_child0$child0 = new _globals.core.Item(this$child0)
		__closure.this_child0$child0 = this_child0$child0

//creating component Item
		this_child0$child0.__create(__closure.__closure_this_child0$child0 = { })
		var this_child0_child0$child0 = new _globals.core.ListView(this_child0$child0)
		__closure.this_child0_child0$child0 = this_child0_child0$child0

//creating component ListView
		this_child0_child0$child0.__create(__closure.__closure_this_child0_child0$child0 = { })
		this_child0_child0$child0.delegate = (function(__parent) {
		var delegate = new _globals.core.Rectangle(__parent, true)
		var __closure = { delegate : delegate }

//creating component Rectangle
			delegate.__create(__closure.__closure_delegate = { })
			var delegate$child0 = new _globals.core.Rectangle(delegate)
			__closure.delegate$child0 = delegate$child0

//creating component Rectangle
			delegate$child0.__create(__closure.__closure_delegate$child0 = { })
			var delegate_child0$child0 = new _globals.core.Text(delegate$child0)
			__closure.delegate_child0$child0 = delegate_child0$child0

//creating component Text
			delegate_child0$child0.__create(__closure.__closure_delegate_child0$child0 = { })

			var delegate_child0$child1 = new _globals.core.MouseArea(delegate$child0)
			__closure.delegate_child0$child1 = delegate_child0$child1

//creating component MouseArea
			delegate_child0$child1.__create(__closure.__closure_delegate_child0$child1 = { })


//setting up component Rectangle
			var delegate = __closure.delegate
			delegate.__setup(__closure.__closure_delegate)
			delete __closure.__closure_delegate

//assigning color to ("transparent")
			delegate._replaceUpdater('color'); delegate.color = (("transparent"));
//assigning width to (this._get('menu')._get('width'))
			var update$delegate$width = (function() { delegate.width = ((this._get('menu')._get('width'))); }).bind(delegate)
			var dep$delegate$width$0 = delegate._get('menu')
			delegate.connectOnChanged(dep$delegate$width$0, 'width', update$delegate$width)
			delegate._replaceUpdater('width', [[dep$delegate$width$0, 'width', update$delegate$width]])
			update$delegate$width();
//assigning border.width to (2)
			delegate._replaceUpdater('border.width'); delegate._get('border').width = ((2));
//assigning border.color to ("#0BBC69")
			delegate._replaceUpdater('border.color'); delegate._get('border').color = (("#0BBC69"));
//assigning height to (56)
			delegate._replaceUpdater('height'); delegate.height = ((56));


//setting up component Rectangle
			var delegate$child0 = __closure.delegate$child0
			delegate$child0.__setup(__closure.__closure_delegate$child0)
			delete __closure.__closure_delegate$child0

//assigning color to ("#0BBC69")
			delegate$child0._replaceUpdater('color'); delegate$child0.color = (("#0BBC69"));
//assigning anchors.leftMargin to (28)
			delegate$child0._replaceUpdater('anchors.leftMargin'); delegate$child0._get('anchors').leftMargin = ((28));
//assigning anchors.fill to (this._get('parent'))
			var update$delegate_child0$anchors_fill = (function() { delegate$child0._get('anchors').fill = ((this._get('parent'))); }).bind(delegate$child0)
			var dep$delegate_child0$anchors_fill$0 = delegate$child0
			delegate$child0.connectOnChanged(dep$delegate_child0$anchors_fill$0, 'parent', update$delegate_child0$anchors_fill)
			delegate$child0._replaceUpdater('anchors.fill', [[dep$delegate_child0$anchors_fill$0, 'parent', update$delegate_child0$anchors_fill]])
			update$delegate_child0$anchors_fill();


//setting up component Text
			var delegate_child0$child0 = __closure.delegate_child0$child0
			delegate_child0$child0.__setup(__closure.__closure_delegate_child0$child0)
			delete __closure.__closure_delegate_child0$child0

//assigning color to ("white")
			delegate_child0$child0._replaceUpdater('color'); delegate_child0$child0.color = (("white"));
//assigning text to (this._get('model').text)
			var update$delegate_child0_child0$text = (function() { delegate_child0$child0.text = ((this._get('model').text)); }).bind(delegate_child0$child0)
			var dep$delegate_child0_child0$text$0 = delegate_child0$child0._get('_delegate')
			delegate_child0$child0.connectOnChanged(dep$delegate_child0_child0$text$0, '_row', update$delegate_child0_child0$text)
			delegate_child0$child0._replaceUpdater('text', [[dep$delegate_child0_child0$text$0, '_row', update$delegate_child0_child0$text]])
			update$delegate_child0_child0$text();
//assigning font.bold to (true)
			delegate_child0$child0._replaceUpdater('font.bold'); delegate_child0$child0._get('font').bold = ((true));
//assigning horizontalAlignment to (_globals.core.Text.prototype.AlignHCenter)
			delegate_child0$child0._replaceUpdater('horizontalAlignment'); delegate_child0$child0.horizontalAlignment = ((_globals.core.Text.prototype.AlignHCenter));
//assigning font.pixelSize to (18)
			delegate_child0$child0._replaceUpdater('font.pixelSize'); delegate_child0$child0._get('font').pixelSize = ((18));
//assigning verticalAlignment to (_globals.core.Text.prototype.AlignVCenter)
			delegate_child0$child0._replaceUpdater('verticalAlignment'); delegate_child0$child0.verticalAlignment = ((_globals.core.Text.prototype.AlignVCenter));
//assigning anchors.fill to (this._get('parent'))
			var update$delegate_child0_child0$anchors_fill = (function() { delegate_child0$child0._get('anchors').fill = ((this._get('parent'))); }).bind(delegate_child0$child0)
			var dep$delegate_child0_child0$anchors_fill$0 = delegate_child0$child0
			delegate_child0$child0.connectOnChanged(dep$delegate_child0_child0$anchors_fill$0, 'parent', update$delegate_child0_child0$anchors_fill)
			delegate_child0$child0._replaceUpdater('anchors.fill', [[dep$delegate_child0_child0$anchors_fill$0, 'parent', update$delegate_child0_child0$anchors_fill]])
			update$delegate_child0_child0$anchors_fill();

			delegate$child0.addChild(delegate_child0$child0)

//setting up component MouseArea
			var delegate_child0$child1 = __closure.delegate_child0$child1
			delegate_child0$child1.__setup(__closure.__closure_delegate_child0$child1)
			delete __closure.__closure_delegate_child0$child1

//assigning anchors.fill to (this._get('parent'))
			var update$delegate_child0_child1$anchors_fill = (function() { delegate_child0$child1._get('anchors').fill = ((this._get('parent'))); }).bind(delegate_child0$child1)
			var dep$delegate_child0_child1$anchors_fill$0 = delegate_child0$child1
			delegate_child0$child1.connectOnChanged(dep$delegate_child0_child1$anchors_fill$0, 'parent', update$delegate_child0_child1$anchors_fill)
			delegate_child0$child1._replaceUpdater('anchors.fill', [[dep$delegate_child0_child1$anchors_fill$0, 'parent', update$delegate_child0_child1$anchors_fill]])
			update$delegate_child0_child1$anchors_fill();
			delegate_child0$child1.on('clicked', (function() {
                                console.log( model.text );
                            } ).bind(delegate_child0$child1))

			delegate$child0.addChild(delegate_child0$child1)
			delegate.addChild(delegate$child0)

		return delegate
})
//creating component src.<anonymous>
		var this_child0_child0_child0$model = new _globals.core.ListModel(this_child0_child0$child0)
		__closure.this_child0_child0_child0$model = this_child0_child0_child0$model

//creating component ListModel
		this_child0_child0_child0$model.__create(__closure.__closure_this_child0_child0_child0$model = { })

		this_child0_child0$child0.model = this_child0_child0_child0$model
		this_child0_child0$child0._setId('menu')
		this_child0$child0._setId('content')
		var this_child0$child1 = new _globals.core.Item(this$child0)
		__closure.this_child0$child1 = this_child0$child1

//creating component Item
		this_child0$child1.__create(__closure.__closure_this_child0$child1 = { })
		var this_child0_child1$child0 = new _globals.core.Rectangle(this_child0$child1)
		__closure.this_child0_child1$child0 = this_child0_child1$child0

//creating component Rectangle
		this_child0_child1$child0.__create(__closure.__closure_this_child0_child1$child0 = { })

		var this_child0_child1$child1 = new _globals.src.ToolbarButton(this_child0$child1)
		__closure.this_child0_child1$child1 = this_child0_child1$child1

//creating component ToolbarButton
		this_child0_child1$child1.__create(__closure.__closure_this_child0_child1$child1 = { })
		this_child0_child1$child1._setId('helpTool')
		var this_child0_child1$child2 = new _globals.src.ToolbarButton(this_child0$child1)
		__closure.this_child0_child1$child2 = this_child0_child1$child2

//creating component ToolbarButton
		this_child0_child1$child2.__create(__closure.__closure_this_child0_child1$child2 = { })
		this_child0_child1$child2._setId('chatTool')
		var this_child0_child1$child3 = new _globals.core.Rectangle(this_child0$child1)
		__closure.this_child0_child1$child3 = this_child0_child1$child3

//creating component Rectangle
		this_child0_child1$child3.__create(__closure.__closure_this_child0_child1$child3 = { })
		var this_child0_child1_child3$child0 = new _globals.src.ToolbarButton(this_child0_child1$child3)
		__closure.this_child0_child1_child3$child0 = this_child0_child1_child3$child0

//creating component ToolbarButton
		this_child0_child1_child3$child0.__create(__closure.__closure_this_child0_child1_child3$child0 = { })

		this_child0_child1$child3._setId('addTool')
		var this_child0_child1$child4 = new _globals.core.Rectangle(this_child0$child1)
		__closure.this_child0_child1$child4 = this_child0_child1$child4

//creating component Rectangle
		this_child0_child1$child4.__create(__closure.__closure_this_child0_child1$child4 = { })
		var this_child0_child1_child4$child0 = new _globals.src.ToolbarButton(this_child0_child1$child4)
		__closure.this_child0_child1_child4$child0 = this_child0_child1_child4$child0

//creating component ToolbarButton
		this_child0_child1_child4$child0.__create(__closure.__closure_this_child0_child1_child4$child0 = { })

		this_child0_child1$child4._setId('chartTool')
		var this_child0_child1$child5 = new _globals.src.ToolbarButton(this_child0$child1)
		__closure.this_child0_child1$child5 = this_child0_child1$child5

//creating component ToolbarButton
		this_child0_child1$child5.__create(__closure.__closure_this_child0_child1$child5 = { })
		this_child0_child1$child5._setId('documentTool')
		var this_child0_child1$child6 = new _globals.src.ToolbarButton(this_child0$child1)
		__closure.this_child0_child1$child6 = this_child0_child1$child6

//creating component ToolbarButton
		this_child0_child1$child6.__create(__closure.__closure_this_child0_child1$child6 = { })
		this_child0_child1$child6._setId('searchTool')
//creating component src.<anonymous>
		var this_child0$gradient = new _globals.core.Gradient(this$child0)
		__closure.this_child0$gradient = this_child0$gradient

//creating component Gradient
		this_child0$gradient.__create(__closure.__closure_this_child0$gradient = { })
		var this_child0_gradient$child0 = new _globals.core.GradientStop(this_child0$gradient)
		__closure.this_child0_gradient$child0 = this_child0_gradient$child0

//creating component GradientStop
		this_child0_gradient$child0.__create(__closure.__closure_this_child0_gradient$child0 = { })

		var this_child0_gradient$child1 = new _globals.core.GradientStop(this_child0$gradient)
		__closure.this_child0_gradient$child1 = this_child0_gradient$child1

//creating component GradientStop
		this_child0_gradient$child1.__create(__closure.__closure_this_child0_gradient$child1 = { })

		this$child0.gradient = this_child0$gradient
		this._setId('root')
	}
	UiAppPrototype.__setup = function(__closure) {
	UiAppBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//assigning anchors.fill to (this._get('context'))
			var update$this$anchors_fill = (function() { this._get('anchors').fill = ((this._get('context'))); }).bind(this)
			var dep$this$anchors_fill$0 = this
			this.connectOnChanged(dep$this$anchors_fill$0, 'context', update$this$anchors_fill)
			this._replaceUpdater('anchors.fill', [[dep$this$anchors_fill$0, 'context', update$this$anchors_fill]])
			update$this$anchors_fill();


//setting up component Rectangle
			var this$child0 = __closure.this$child0
			this$child0.__setup(__closure.__closure_this$child0)
			delete __closure.__closure_this$child0


//setting up component Gradient
			var this_child0$gradient = __closure.this_child0$gradient
			this_child0$gradient.__setup(__closure.__closure_this_child0$gradient)
			delete __closure.__closure_this_child0$gradient



//setting up component GradientStop
			var this_child0_gradient$child0 = __closure.this_child0_gradient$child0
			this_child0_gradient$child0.__setup(__closure.__closure_this_child0_gradient$child0)
			delete __closure.__closure_this_child0_gradient$child0

//assigning color to ("#64B2FB")
			this_child0_gradient$child0._replaceUpdater('color'); this_child0_gradient$child0.color = (("#64B2FB"));
//assigning position to (0)
			this_child0_gradient$child0._replaceUpdater('position'); this_child0_gradient$child0.position = ((0));

			this_child0$gradient.addChild(this_child0_gradient$child0)

//setting up component GradientStop
			var this_child0_gradient$child1 = __closure.this_child0_gradient$child1
			this_child0_gradient$child1.__setup(__closure.__closure_this_child0_gradient$child1)
			delete __closure.__closure_this_child0_gradient$child1

//assigning color to ("#0ABE63")
			this_child0_gradient$child1._replaceUpdater('color'); this_child0_gradient$child1.color = (("#0ABE63"));
//assigning position to (1)
			this_child0_gradient$child1._replaceUpdater('position'); this_child0_gradient$child1.position = ((1));

			this_child0$gradient.addChild(this_child0_gradient$child1)
//assigning width to (414)
			this$child0._replaceUpdater('width'); this$child0.width = ((414));
//assigning anchors.centerIn to (this._get('parent'))
			var update$this_child0$anchors_centerIn = (function() { this$child0._get('anchors').centerIn = ((this._get('parent'))); }).bind(this$child0)
			var dep$this_child0$anchors_centerIn$0 = this$child0
			this$child0.connectOnChanged(dep$this_child0$anchors_centerIn$0, 'parent', update$this_child0$anchors_centerIn)
			this$child0._replaceUpdater('anchors.centerIn', [[dep$this_child0$anchors_centerIn$0, 'parent', update$this_child0$anchors_centerIn]])
			update$this_child0$anchors_centerIn();
//assigning height to (736)
			this$child0._replaceUpdater('height'); this$child0.height = ((736));


//setting up component Item
			var this_child0$child0 = __closure.this_child0$child0
			this_child0$child0.__setup(__closure.__closure_this_child0$child0)
			delete __closure.__closure_this_child0$child0

//assigning anchors.rightMargin to (24)
			this_child0$child0._replaceUpdater('anchors.rightMargin'); this_child0$child0._get('anchors').rightMargin = ((24));
//assigning anchors.bottomMargin to (64)
			this_child0$child0._replaceUpdater('anchors.bottomMargin'); this_child0$child0._get('anchors').bottomMargin = ((64));
//assigning anchors.leftMargin to (24)
			this_child0$child0._replaceUpdater('anchors.leftMargin'); this_child0$child0._get('anchors').leftMargin = ((24));
//assigning anchors.topMargin to (64)
			this_child0$child0._replaceUpdater('anchors.topMargin'); this_child0$child0._get('anchors').topMargin = ((64));
//assigning anchors.fill to (this._get('parent'))
			var update$this_child0_child0$anchors_fill = (function() { this_child0$child0._get('anchors').fill = ((this._get('parent'))); }).bind(this_child0$child0)
			var dep$this_child0_child0$anchors_fill$0 = this_child0$child0
			this_child0$child0.connectOnChanged(dep$this_child0_child0$anchors_fill$0, 'parent', update$this_child0_child0$anchors_fill)
			this_child0$child0._replaceUpdater('anchors.fill', [[dep$this_child0_child0$anchors_fill$0, 'parent', update$this_child0_child0$anchors_fill]])
			update$this_child0_child0$anchors_fill();


//setting up component ListView
			var this_child0_child0$child0 = __closure.this_child0_child0$child0
			this_child0_child0$child0.__setup(__closure.__closure_this_child0_child0$child0)
			delete __closure.__closure_this_child0_child0$child0


//setting up component ListModel
			var this_child0_child0_child0$model = __closure.this_child0_child0_child0$model
			this_child0_child0_child0$model.__setup(__closure.__closure_this_child0_child0_child0$model)
			delete __closure.__closure_this_child0_child0_child0$model


	this_child0_child0_child0$model.assign([{"text": "Coming home from hospital"}, {"text": "Stress after trauma"}, {"text": "Depression"}, {"text": "Managing difficult feelings"}, {"text": "How to help a loved one"}, {"text": "When do I ask for help?"}, {"text": "Treatment approaches"}, {"text": "Helpful organisations"}])
//assigning spacing to (16)
			this_child0_child0$child0._replaceUpdater('spacing'); this_child0_child0$child0.spacing = ((16));
//assigning anchors.fill to (this._get('parent'))
			var update$this_child0_child0_child0$anchors_fill = (function() { this_child0_child0$child0._get('anchors').fill = ((this._get('parent'))); }).bind(this_child0_child0$child0)
			var dep$this_child0_child0_child0$anchors_fill$0 = this_child0_child0$child0
			this_child0_child0$child0.connectOnChanged(dep$this_child0_child0_child0$anchors_fill$0, 'parent', update$this_child0_child0_child0$anchors_fill)
			this_child0_child0$child0._replaceUpdater('anchors.fill', [[dep$this_child0_child0_child0$anchors_fill$0, 'parent', update$this_child0_child0_child0$anchors_fill]])
			update$this_child0_child0_child0$anchors_fill();

			this_child0$child0.addChild(this_child0_child0$child0)
			this$child0.addChild(this_child0$child0)

//setting up component Item
			var this_child0$child1 = __closure.this_child0$child1
			this_child0$child1.__setup(__closure.__closure_this_child0$child1)
			delete __closure.__closure_this_child0$child1

//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1$anchors_bottom = (function() { this_child0$child1._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0$child1)
			var dep$this_child0_child1$anchors_bottom$0 = this_child0$child1._get('parent')
			this_child0$child1.connectOnChanged(dep$this_child0_child1$anchors_bottom$0, 'bottom', update$this_child0_child1$anchors_bottom)
			this_child0$child1._replaceUpdater('anchors.bottom', [[dep$this_child0_child1$anchors_bottom$0, 'bottom', update$this_child0_child1$anchors_bottom]])
			update$this_child0_child1$anchors_bottom();
//assigning anchors.right to (this._get('parent')._get('right'))
			var update$this_child0_child1$anchors_right = (function() { this_child0$child1._get('anchors').right = ((this._get('parent')._get('right'))); }).bind(this_child0$child1)
			var dep$this_child0_child1$anchors_right$0 = this_child0$child1._get('parent')
			this_child0$child1.connectOnChanged(dep$this_child0_child1$anchors_right$0, 'right', update$this_child0_child1$anchors_right)
			this_child0$child1._replaceUpdater('anchors.right', [[dep$this_child0_child1$anchors_right$0, 'right', update$this_child0_child1$anchors_right]])
			update$this_child0_child1$anchors_right();
//assigning anchors.left to (this._get('parent')._get('left'))
			var update$this_child0_child1$anchors_left = (function() { this_child0$child1._get('anchors').left = ((this._get('parent')._get('left'))); }).bind(this_child0$child1)
			var dep$this_child0_child1$anchors_left$0 = this_child0$child1._get('parent')
			this_child0$child1.connectOnChanged(dep$this_child0_child1$anchors_left$0, 'left', update$this_child0_child1$anchors_left)
			this_child0$child1._replaceUpdater('anchors.left', [[dep$this_child0_child1$anchors_left$0, 'left', update$this_child0_child1$anchors_left]])
			update$this_child0_child1$anchors_left();
//assigning height to (64)
			this_child0$child1._replaceUpdater('height'); this_child0$child1.height = ((64));


//setting up component Rectangle
			var this_child0_child1$child0 = __closure.this_child0_child1$child0
			this_child0_child1$child0.__setup(__closure.__closure_this_child0_child1$child0)
			delete __closure.__closure_this_child0_child1$child0

//assigning color to ("#EB5E28")
			this_child0_child1$child0._replaceUpdater('color'); this_child0_child1$child0.color = (("#EB5E28"));
//assigning anchors.right to (this._get('parent')._get('right'))
			var update$this_child0_child1_child0$anchors_right = (function() { this_child0_child1$child0._get('anchors').right = ((this._get('parent')._get('right'))); }).bind(this_child0_child1$child0)
			var dep$this_child0_child1_child0$anchors_right$0 = this_child0_child1$child0._get('parent')
			this_child0_child1$child0.connectOnChanged(dep$this_child0_child1_child0$anchors_right$0, 'right', update$this_child0_child1_child0$anchors_right)
			this_child0_child1$child0._replaceUpdater('anchors.right', [[dep$this_child0_child1_child0$anchors_right$0, 'right', update$this_child0_child1_child0$anchors_right]])
			update$this_child0_child1_child0$anchors_right();
//assigning anchors.left to (this._get('parent')._get('left'))
			var update$this_child0_child1_child0$anchors_left = (function() { this_child0_child1$child0._get('anchors').left = ((this._get('parent')._get('left'))); }).bind(this_child0_child1$child0)
			var dep$this_child0_child1_child0$anchors_left$0 = this_child0_child1$child0._get('parent')
			this_child0_child1$child0.connectOnChanged(dep$this_child0_child1_child0$anchors_left$0, 'left', update$this_child0_child1_child0$anchors_left)
			this_child0_child1$child0._replaceUpdater('anchors.left', [[dep$this_child0_child1_child0$anchors_left$0, 'left', update$this_child0_child1_child0$anchors_left]])
			update$this_child0_child1_child0$anchors_left();
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child0$anchors_bottom = (function() { this_child0_child1$child0._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child0)
			var dep$this_child0_child1_child0$anchors_bottom$0 = this_child0_child1$child0._get('parent')
			this_child0_child1$child0.connectOnChanged(dep$this_child0_child1_child0$anchors_bottom$0, 'bottom', update$this_child0_child1_child0$anchors_bottom)
			this_child0_child1$child0._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child0$anchors_bottom$0, 'bottom', update$this_child0_child1_child0$anchors_bottom]])
			update$this_child0_child1_child0$anchors_bottom();
//assigning height to (32)
			this_child0_child1$child0._replaceUpdater('height'); this_child0_child1$child0.height = ((32));

			this_child0$child1.addChild(this_child0_child1$child0)

//setting up component ToolbarButton
			var this_child0_child1$child1 = __closure.this_child0_child1$child1
			this_child0_child1$child1.__setup(__closure.__closure_this_child0_child1$child1)
			delete __closure.__closure_this_child0_child1$child1

//assigning anchors.rightMargin to (8)
			this_child0_child1$child1._replaceUpdater('anchors.rightMargin'); this_child0_child1$child1._get('anchors').rightMargin = ((8));
//assigning anchors.right to (this._get('chatTool')._get('left'))
			var update$this_child0_child1_child1$anchors_right = (function() { this_child0_child1$child1._get('anchors').right = ((this._get('chatTool')._get('left'))); }).bind(this_child0_child1$child1)
			var dep$this_child0_child1_child1$anchors_right$0 = this_child0_child1$child1._get('chatTool')
			this_child0_child1$child1.connectOnChanged(dep$this_child0_child1_child1$anchors_right$0, 'left', update$this_child0_child1_child1$anchors_right)
			this_child0_child1$child1._replaceUpdater('anchors.right', [[dep$this_child0_child1_child1$anchors_right$0, 'left', update$this_child0_child1_child1$anchors_right]])
			update$this_child0_child1_child1$anchors_right();
//assigning background to ("#EB5E28")
			this_child0_child1$child1._replaceUpdater('background'); this_child0_child1$child1.background = (("#EB5E28"));
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child1$anchors_bottom = (function() { this_child0_child1$child1._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child1)
			var dep$this_child0_child1_child1$anchors_bottom$0 = this_child0_child1$child1._get('parent')
			this_child0_child1$child1.connectOnChanged(dep$this_child0_child1_child1$anchors_bottom$0, 'bottom', update$this_child0_child1_child1$anchors_bottom)
			this_child0_child1$child1._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child1$anchors_bottom$0, 'bottom', update$this_child0_child1_child1$anchors_bottom]])
			update$this_child0_child1_child1$anchors_bottom();
//assigning icon to ("icons/help-white.png")
			this_child0_child1$child1._replaceUpdater('icon'); this_child0_child1$child1.icon = (("icons/help-white.png"));

			this_child0$child1.addChild(this_child0_child1$child1)

//setting up component ToolbarButton
			var this_child0_child1$child2 = __closure.this_child0_child1$child2
			this_child0_child1$child2.__setup(__closure.__closure_this_child0_child1$child2)
			delete __closure.__closure_this_child0_child1$child2

//assigning anchors.rightMargin to (8)
			this_child0_child1$child2._replaceUpdater('anchors.rightMargin'); this_child0_child1$child2._get('anchors').rightMargin = ((8));
//assigning anchors.right to (this._get('addTool')._get('left'))
			var update$this_child0_child1_child2$anchors_right = (function() { this_child0_child1$child2._get('anchors').right = ((this._get('addTool')._get('left'))); }).bind(this_child0_child1$child2)
			var dep$this_child0_child1_child2$anchors_right$0 = this_child0_child1$child2._get('addTool')
			this_child0_child1$child2.connectOnChanged(dep$this_child0_child1_child2$anchors_right$0, 'left', update$this_child0_child1_child2$anchors_right)
			this_child0_child1$child2._replaceUpdater('anchors.right', [[dep$this_child0_child1_child2$anchors_right$0, 'left', update$this_child0_child1_child2$anchors_right]])
			update$this_child0_child1_child2$anchors_right();
//assigning background to ("#EB5E28")
			this_child0_child1$child2._replaceUpdater('background'); this_child0_child1$child2.background = (("#EB5E28"));
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child2$anchors_bottom = (function() { this_child0_child1$child2._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child2)
			var dep$this_child0_child1_child2$anchors_bottom$0 = this_child0_child1$child2._get('parent')
			this_child0_child1$child2.connectOnChanged(dep$this_child0_child1_child2$anchors_bottom$0, 'bottom', update$this_child0_child1_child2$anchors_bottom)
			this_child0_child1$child2._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child2$anchors_bottom$0, 'bottom', update$this_child0_child1_child2$anchors_bottom]])
			update$this_child0_child1_child2$anchors_bottom();
//assigning icon to ("icons/chat-white.png")
			this_child0_child1$child2._replaceUpdater('icon'); this_child0_child1$child2.icon = (("icons/chat-white.png"));

			this_child0$child1.addChild(this_child0_child1$child2)

//setting up component Rectangle
			var this_child0_child1$child3 = __closure.this_child0_child1$child3
			this_child0_child1$child3.__setup(__closure.__closure_this_child0_child1$child3)
			delete __closure.__closure_this_child0_child1$child3

//assigning anchors.rightMargin to (- 4)
			this_child0_child1$child3._replaceUpdater('anchors.rightMargin'); this_child0_child1$child3._get('anchors').rightMargin = ((- 4));
//assigning color to ("#EB5E28")
			this_child0_child1$child3._replaceUpdater('color'); this_child0_child1$child3.color = (("#EB5E28"));
//assigning height to (64)
			this_child0_child1$child3._replaceUpdater('height'); this_child0_child1$child3.height = ((64));
//assigning width to (64)
			this_child0_child1$child3._replaceUpdater('width'); this_child0_child1$child3.width = ((64));
//assigning anchors.right to (this._get('parent')._get('horizontalCenter'))
			var update$this_child0_child1_child3$anchors_right = (function() { this_child0_child1$child3._get('anchors').right = ((this._get('parent')._get('horizontalCenter'))); }).bind(this_child0_child1$child3)
			var dep$this_child0_child1_child3$anchors_right$0 = this_child0_child1$child3._get('parent')
			this_child0_child1$child3.connectOnChanged(dep$this_child0_child1_child3$anchors_right$0, 'horizontalCenter', update$this_child0_child1_child3$anchors_right)
			this_child0_child1$child3._replaceUpdater('anchors.right', [[dep$this_child0_child1_child3$anchors_right$0, 'horizontalCenter', update$this_child0_child1_child3$anchors_right]])
			update$this_child0_child1_child3$anchors_right();
//assigning radius to (32)
			this_child0_child1$child3._replaceUpdater('radius'); this_child0_child1$child3.radius = ((32));
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child3$anchors_bottom = (function() { this_child0_child1$child3._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child3)
			var dep$this_child0_child1_child3$anchors_bottom$0 = this_child0_child1$child3._get('parent')
			this_child0_child1$child3.connectOnChanged(dep$this_child0_child1_child3$anchors_bottom$0, 'bottom', update$this_child0_child1_child3$anchors_bottom)
			this_child0_child1$child3._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child3$anchors_bottom$0, 'bottom', update$this_child0_child1_child3$anchors_bottom]])
			update$this_child0_child1_child3$anchors_bottom();


//setting up component ToolbarButton
			var this_child0_child1_child3$child0 = __closure.this_child0_child1_child3$child0
			this_child0_child1_child3$child0.__setup(__closure.__closure_this_child0_child1_child3$child0)
			delete __closure.__closure_this_child0_child1_child3$child0

//assigning anchors.margins to (8)
			this_child0_child1_child3$child0._replaceUpdater('anchors.margins'); this_child0_child1_child3$child0._get('anchors').margins = ((8));
//assigning icon to ("icons/add-white.png")
			this_child0_child1_child3$child0._replaceUpdater('icon'); this_child0_child1_child3$child0.icon = (("icons/add-white.png"));
//assigning background to ("#364958")
			this_child0_child1_child3$child0._replaceUpdater('background'); this_child0_child1_child3$child0.background = (("#364958"));
//assigning anchors.fill to (this._get('parent'))
			var update$this_child0_child1_child3_child0$anchors_fill = (function() { this_child0_child1_child3$child0._get('anchors').fill = ((this._get('parent'))); }).bind(this_child0_child1_child3$child0)
			var dep$this_child0_child1_child3_child0$anchors_fill$0 = this_child0_child1_child3$child0
			this_child0_child1_child3$child0.connectOnChanged(dep$this_child0_child1_child3_child0$anchors_fill$0, 'parent', update$this_child0_child1_child3_child0$anchors_fill)
			this_child0_child1_child3$child0._replaceUpdater('anchors.fill', [[dep$this_child0_child1_child3_child0$anchors_fill$0, 'parent', update$this_child0_child1_child3_child0$anchors_fill]])
			update$this_child0_child1_child3_child0$anchors_fill();

			this_child0_child1$child3.addChild(this_child0_child1_child3$child0)
			this_child0$child1.addChild(this_child0_child1$child3)

//setting up component Rectangle
			var this_child0_child1$child4 = __closure.this_child0_child1$child4
			this_child0_child1$child4.__setup(__closure.__closure_this_child0_child1$child4)
			delete __closure.__closure_this_child0_child1$child4

//assigning color to ("#EB5E28")
			this_child0_child1$child4._replaceUpdater('color'); this_child0_child1$child4.color = (("#EB5E28"));
//assigning height to (64)
			this_child0_child1$child4._replaceUpdater('height'); this_child0_child1$child4.height = ((64));
//assigning width to (64)
			this_child0_child1$child4._replaceUpdater('width'); this_child0_child1$child4.width = ((64));
//assigning radius to (32)
			this_child0_child1$child4._replaceUpdater('radius'); this_child0_child1$child4.radius = ((32));
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child4$anchors_bottom = (function() { this_child0_child1$child4._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child4)
			var dep$this_child0_child1_child4$anchors_bottom$0 = this_child0_child1$child4._get('parent')
			this_child0_child1$child4.connectOnChanged(dep$this_child0_child1_child4$anchors_bottom$0, 'bottom', update$this_child0_child1_child4$anchors_bottom)
			this_child0_child1$child4._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child4$anchors_bottom$0, 'bottom', update$this_child0_child1_child4$anchors_bottom]])
			update$this_child0_child1_child4$anchors_bottom();
//assigning anchors.leftMargin to (- 4)
			this_child0_child1$child4._replaceUpdater('anchors.leftMargin'); this_child0_child1$child4._get('anchors').leftMargin = ((- 4));
//assigning anchors.left to (this._get('parent')._get('horizontalCenter'))
			var update$this_child0_child1_child4$anchors_left = (function() { this_child0_child1$child4._get('anchors').left = ((this._get('parent')._get('horizontalCenter'))); }).bind(this_child0_child1$child4)
			var dep$this_child0_child1_child4$anchors_left$0 = this_child0_child1$child4._get('parent')
			this_child0_child1$child4.connectOnChanged(dep$this_child0_child1_child4$anchors_left$0, 'horizontalCenter', update$this_child0_child1_child4$anchors_left)
			this_child0_child1$child4._replaceUpdater('anchors.left', [[dep$this_child0_child1_child4$anchors_left$0, 'horizontalCenter', update$this_child0_child1_child4$anchors_left]])
			update$this_child0_child1_child4$anchors_left();


//setting up component ToolbarButton
			var this_child0_child1_child4$child0 = __closure.this_child0_child1_child4$child0
			this_child0_child1_child4$child0.__setup(__closure.__closure_this_child0_child1_child4$child0)
			delete __closure.__closure_this_child0_child1_child4$child0

//assigning anchors.margins to (8)
			this_child0_child1_child4$child0._replaceUpdater('anchors.margins'); this_child0_child1_child4$child0._get('anchors').margins = ((8));
//assigning icon to ("icons/chart-white.png")
			this_child0_child1_child4$child0._replaceUpdater('icon'); this_child0_child1_child4$child0.icon = (("icons/chart-white.png"));
//assigning background to ("#364958")
			this_child0_child1_child4$child0._replaceUpdater('background'); this_child0_child1_child4$child0.background = (("#364958"));
//assigning anchors.fill to (this._get('parent'))
			var update$this_child0_child1_child4_child0$anchors_fill = (function() { this_child0_child1_child4$child0._get('anchors').fill = ((this._get('parent'))); }).bind(this_child0_child1_child4$child0)
			var dep$this_child0_child1_child4_child0$anchors_fill$0 = this_child0_child1_child4$child0
			this_child0_child1_child4$child0.connectOnChanged(dep$this_child0_child1_child4_child0$anchors_fill$0, 'parent', update$this_child0_child1_child4_child0$anchors_fill)
			this_child0_child1_child4$child0._replaceUpdater('anchors.fill', [[dep$this_child0_child1_child4_child0$anchors_fill$0, 'parent', update$this_child0_child1_child4_child0$anchors_fill]])
			update$this_child0_child1_child4_child0$anchors_fill();

			this_child0_child1$child4.addChild(this_child0_child1_child4$child0)
			this_child0$child1.addChild(this_child0_child1$child4)

//setting up component ToolbarButton
			var this_child0_child1$child5 = __closure.this_child0_child1$child5
			this_child0_child1$child5.__setup(__closure.__closure_this_child0_child1$child5)
			delete __closure.__closure_this_child0_child1$child5

//assigning anchors.leftMargin to (8)
			this_child0_child1$child5._replaceUpdater('anchors.leftMargin'); this_child0_child1$child5._get('anchors').leftMargin = ((8));
//assigning background to ("#EB5E28")
			this_child0_child1$child5._replaceUpdater('background'); this_child0_child1$child5.background = (("#EB5E28"));
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child5$anchors_bottom = (function() { this_child0_child1$child5._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child5)
			var dep$this_child0_child1_child5$anchors_bottom$0 = this_child0_child1$child5._get('parent')
			this_child0_child1$child5.connectOnChanged(dep$this_child0_child1_child5$anchors_bottom$0, 'bottom', update$this_child0_child1_child5$anchors_bottom)
			this_child0_child1$child5._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child5$anchors_bottom$0, 'bottom', update$this_child0_child1_child5$anchors_bottom]])
			update$this_child0_child1_child5$anchors_bottom();
//assigning anchors.left to (this._get('chartTool')._get('right'))
			var update$this_child0_child1_child5$anchors_left = (function() { this_child0_child1$child5._get('anchors').left = ((this._get('chartTool')._get('right'))); }).bind(this_child0_child1$child5)
			var dep$this_child0_child1_child5$anchors_left$0 = this_child0_child1$child5._get('chartTool')
			this_child0_child1$child5.connectOnChanged(dep$this_child0_child1_child5$anchors_left$0, 'right', update$this_child0_child1_child5$anchors_left)
			this_child0_child1$child5._replaceUpdater('anchors.left', [[dep$this_child0_child1_child5$anchors_left$0, 'right', update$this_child0_child1_child5$anchors_left]])
			update$this_child0_child1_child5$anchors_left();
//assigning icon to ("icons/document-white.png")
			this_child0_child1$child5._replaceUpdater('icon'); this_child0_child1$child5.icon = (("icons/document-white.png"));

			this_child0$child1.addChild(this_child0_child1$child5)

//setting up component ToolbarButton
			var this_child0_child1$child6 = __closure.this_child0_child1$child6
			this_child0_child1$child6.__setup(__closure.__closure_this_child0_child1$child6)
			delete __closure.__closure_this_child0_child1$child6

//assigning anchors.leftMargin to (8)
			this_child0_child1$child6._replaceUpdater('anchors.leftMargin'); this_child0_child1$child6._get('anchors').leftMargin = ((8));
//assigning background to ("#EB5E28")
			this_child0_child1$child6._replaceUpdater('background'); this_child0_child1$child6.background = (("#EB5E28"));
//assigning anchors.bottom to (this._get('parent')._get('bottom'))
			var update$this_child0_child1_child6$anchors_bottom = (function() { this_child0_child1$child6._get('anchors').bottom = ((this._get('parent')._get('bottom'))); }).bind(this_child0_child1$child6)
			var dep$this_child0_child1_child6$anchors_bottom$0 = this_child0_child1$child6._get('parent')
			this_child0_child1$child6.connectOnChanged(dep$this_child0_child1_child6$anchors_bottom$0, 'bottom', update$this_child0_child1_child6$anchors_bottom)
			this_child0_child1$child6._replaceUpdater('anchors.bottom', [[dep$this_child0_child1_child6$anchors_bottom$0, 'bottom', update$this_child0_child1_child6$anchors_bottom]])
			update$this_child0_child1_child6$anchors_bottom();
//assigning anchors.left to (this._get('documentTool')._get('right'))
			var update$this_child0_child1_child6$anchors_left = (function() { this_child0_child1$child6._get('anchors').left = ((this._get('documentTool')._get('right'))); }).bind(this_child0_child1$child6)
			var dep$this_child0_child1_child6$anchors_left$0 = this_child0_child1$child6._get('documentTool')
			this_child0_child1$child6.connectOnChanged(dep$this_child0_child1_child6$anchors_left$0, 'right', update$this_child0_child1_child6$anchors_left)
			this_child0_child1$child6._replaceUpdater('anchors.left', [[dep$this_child0_child1_child6$anchors_left$0, 'right', update$this_child0_child1_child6$anchors_left]])
			update$this_child0_child1_child6$anchors_left();
//assigning icon to ("icons/search-white.png")
			this_child0_child1$child6._replaceUpdater('icon'); this_child0_child1$child6.icon = (("icons/search-white.png"));

			this_child0$child1.addChild(this_child0_child1$child6)
			this$child0.addChild(this_child0$child1)
			this.addChild(this$child0)
}


//=====[component core.GradientStop]=====================

	var GradientStopBaseComponent = _globals.core.Object
	var GradientStopBasePrototype = GradientStopBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var GradientStopComponent = _globals.core.GradientStop = function(parent, _delegate) {
		GradientStopBaseComponent.apply(this, arguments)

	}
	var GradientStopPrototype = GradientStopComponent.prototype = Object.create(GradientStopBasePrototype)

	GradientStopPrototype.constructor = GradientStopComponent

	GradientStopPrototype.componentName = 'core.GradientStop'
	GradientStopPrototype._getDeclaration = function() {
		return _globals.core.normalizeColor(this.color) + " " + Math.floor(100 * this.position) + "%"
	}
	core.addProperty(GradientStopPrototype, 'real', 'position')
	core.addProperty(GradientStopPrototype, 'Color', 'color')
	_globals.core._protoOnChanged(GradientStopPrototype, 'position', (function(value) {
		this.parent._updateStyle()
	} ))
	_globals.core._protoOnChanged(GradientStopPrototype, 'color', (function(value) {
		this.parent._updateStyle()
	} ))

//=====[component core.BaseView]=====================

	var BaseViewBaseComponent = _globals.core.BaseLayout
	var BaseViewBasePrototype = BaseViewBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.BaseLayout}
 */
	var BaseViewComponent = _globals.core.BaseView = function(parent, _delegate) {
		BaseViewBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._items = []
		this._modelUpdate = new _globals.core.model.ModelUpdate()
	}

	}
	var BaseViewPrototype = BaseViewComponent.prototype = Object.create(BaseViewBasePrototype)

	BaseViewPrototype.constructor = BaseViewComponent

	BaseViewPrototype.componentName = 'core.BaseView'
	BaseViewPrototype.layoutFinished = _globals.core.createSignal('layoutFinished')
	BaseViewPrototype._onRowsRemoved = function(begin,end) {
		if (this.trace)
			log("rows removed", begin, end)

		this._modelUpdate.remove(this.model, begin, end)
		this._scheduleLayout()
	}
	BaseViewPrototype._updateDelegateIndex = function(idx) {
		var item = this._items[idx]
		if (item) {
			item._local.model.index = idx
			_globals.core.Object.prototype._update.call(item, '_rowIndex')
		}
	}
	BaseViewPrototype.focusCurrent = function() {
		var n = this.count
		if (n == 0)
			return

		var idx = this.currentIndex
		if (idx < 0 || idx >= n) {
			if (this.keyNavigationWraps)
				this.currentIndex = (idx + n) % n
			else
				this.currentIndex = idx < 0? 0: n - 1
			return
		}
		var item = this._items[idx]

		if (item)
			this.focusChild(item)
		if (this.contentFollowsCurrentItem)
			this.positionViewAtIndex(idx)
	}
	BaseViewPrototype._updateScrollPositions = function(x,y) {
		this._setProperty('contentX', x)
		this._setProperty('contentY', y)
		this.content._updateScrollPositions(x, y)
	}
	BaseViewPrototype._updateItems = function(begin,end) {
		for(var i = begin; i < end; ++i)
			this._updateDelegate(i)
	}
	BaseViewPrototype._createDelegate = function(idx) {
		var items = this._items
		if (items[idx] !== null)
			return

		var row = this.model.get(idx)
		row['index'] = idx
		this._local['model'] = row

		var item = this.delegate(this)
		items[idx] = item
		item.view = this
		item.element.remove()
		this.content.element.append(item.element)

		item._local['model'] = row
		delete this._local['model']
		item.recursiveVisible = this.recursiveVisible && item.visible && item.visibleInView

		return item
	}
	BaseViewPrototype._updateDelegate = function(idx) {
		var item = this._items[idx]
		if (item) {
			var row = this.model.get(idx)
			row.index = idx
			item._local.model = row
			_globals.core.Object.prototype._update.call(item, '_row')
		}
	}
	BaseViewPrototype._insertItems = function(begin,end) {
		var n = end - begin + 2
		var args = Array(n)
		args[0] = begin
		args[1] = 0
		for(var i = 2; i < n; ++i)
			args[i] = null
		Array.prototype.splice.apply(this._items, args)
	}
	BaseViewPrototype._onReset = function() {
		var model = this.model
		if (this.trace)
			log("reset", this._items.length, model.count)

		this._modelUpdate.reset(model)
		this._scheduleLayout()
	}
	BaseViewPrototype._discardItem = function(item) {
		if (item === null)
			return
		if (this.focusedChild === item)
			this.focusedChild = null;
		item.discard()
	}
	BaseViewPrototype._onRowsChanged = function(begin,end) {
		if (this.trace)
			log("rows changed", begin, end)

		this._modelUpdate.update(this.model, begin, end)
		this._scheduleLayout()
	}
	BaseViewPrototype._onRowsInserted = function(begin,end) {
		if (this.trace)
			log("rows inserted", begin, end)

		this._modelUpdate.insert(this.model, begin, end)
		this._scheduleLayout()
	}
	BaseViewPrototype._removeItems = function(begin,end) {
		var deleted = this._items.splice(begin, end - begin)
		var view = this
		deleted.forEach(function(item) { view._discardItem(item)})
	}
	BaseViewPrototype.itemAt = function(x,y) {
		var idx = this.indexAt(x, y)
		return idx >= 0? this._items[idx]: null
	}
	BaseViewPrototype._attach = function() {
		if (this._attached || !this.model || !this.delegate)
			return

		this.model.on('reset', this._onReset.bind(this))
		this.model.on('rowsInserted', this._onRowsInserted.bind(this))
		this.model.on('rowsChanged', this._onRowsChanged.bind(this))
		this.model.on('rowsRemoved', this._onRowsRemoved.bind(this))
		this._attached = true
		this._onReset()
	}
	BaseViewPrototype._processUpdates = function() {
		this._modelUpdate.apply(this)
		qml.core.BaseLayout.prototype._processUpdates.apply(this)
	}
	core.addProperty(BaseViewPrototype, 'Object', 'model')
	core.addProperty(BaseViewPrototype, 'Item', 'delegate')
	core.addProperty(BaseViewPrototype, 'int', 'contentX')
	core.addProperty(BaseViewPrototype, 'int', 'contentY')
	core.addProperty(BaseViewPrototype, 'int', 'scrollingStep', (0))
	core.addProperty(BaseViewPrototype, 'int', 'animationDuration', (0))
	core.addProperty(BaseViewPrototype, 'bool', 'contentFollowsCurrentItem', (true))
	core.addProperty(BaseViewPrototype, 'bool', 'nativeScrolling')
	core.addProperty(BaseViewPrototype, 'real', 'prerender', (0.5))
	core.addProperty(BaseViewPrototype, 'BaseViewContent', 'content')
/** @const @type {number} */
	BaseViewPrototype.Beginning = 0
/** @const @type {number} */
	BaseViewComponent.Beginning = 0
/** @const @type {number} */
	BaseViewPrototype.Center = 1
/** @const @type {number} */
	BaseViewComponent.Center = 1
/** @const @type {number} */
	BaseViewPrototype.End = 2
/** @const @type {number} */
	BaseViewComponent.End = 2
/** @const @type {number} */
	BaseViewPrototype.Visible = 3
/** @const @type {number} */
	BaseViewComponent.Visible = 3
/** @const @type {number} */
	BaseViewPrototype.Contain = 4
/** @const @type {number} */
	BaseViewComponent.Contain = 4
/** @const @type {number} */
	BaseViewPrototype.Page = 5
/** @const @type {number} */
	BaseViewComponent.Page = 5
	core.addProperty(BaseViewPrototype, 'enum', 'positionMode')
	_globals.core._protoOnChanged(BaseViewPrototype, 'delegate', (function(value) {
		if (value)
			value.visible = false
	} ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'height', (function(value) { this._scheduleLayout() } ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'contentY', (function(value) { this.content.y = -value; } ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'recursiveVisible', (function(value) {
		if (value)
			this._scheduleLayout();

		this._items.forEach(function(child) {
			if (child !== null)
				child.recursiveVisible = value && child.visible && child.visibleInView
		})
	} ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'width', (function(value) { this._scheduleLayout() } ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'contentX', (function(value) { this.content.x = -value; } ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'focusedChild', (function(value) {
		var idx = this._items.indexOf(this.focusedChild)
		if (idx >= 0)
			this.currentIndex = idx
	} ))
	_globals.core._protoOnChanged(BaseViewPrototype, 'currentIndex', (function(value) {
		this.focusCurrent()
	} ))

	BaseViewPrototype.__create = function(__closure) {
		BaseViewBasePrototype.__create.call(this, __closure.__base = { })
//creating component core.<anonymous>
		var this$content = new _globals.core.BaseViewContent(this)
		__closure.this$content = this$content

//creating component BaseViewContent
		this$content.__create(__closure.__closure_this$content = { })

		this.content = this$content
	}
	BaseViewPrototype.__setup = function(__closure) {
	BaseViewBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//assigning keyNavigationWraps to (true)
			this._replaceUpdater('keyNavigationWraps'); this.keyNavigationWraps = ((true));
//assigning contentWidth to (1)
			this._replaceUpdater('contentWidth'); this.contentWidth = ((1));
//assigning contentHeight to (1)
			this._replaceUpdater('contentHeight'); this.contentHeight = ((1));
//assigning handleNavigationKeys to (true)
			this._replaceUpdater('handleNavigationKeys'); this.handleNavigationKeys = ((true));

//setting up component BaseViewContent
			var this$content = __closure.this$content
			this$content.__setup(__closure.__closure_this$content)
			delete __closure.__closure_this$content

	var behavior_this_content_on_y = new _globals.core.Animation(this$content)
	var behavior_this_content_on_y__closure = { behavior_this_content_on_y: behavior_this_content_on_y }

//creating component Animation
	behavior_this_content_on_y.__create(behavior_this_content_on_y__closure.__closure_behavior_this_content_on_y = { })


//setting up component Animation
	var behavior_this_content_on_y = behavior_this_content_on_y__closure.behavior_this_content_on_y
	behavior_this_content_on_y.__setup(behavior_this_content_on_y__closure.__closure_behavior_this_content_on_y)
	delete behavior_this_content_on_y__closure.__closure_behavior_this_content_on_y

//assigning duration to (this._get('parent')._get('parent')._get('animationDuration'))
	var update$behavior_this_content_on_y$duration = (function() { behavior_this_content_on_y.duration = ((this._get('parent')._get('parent')._get('animationDuration'))); }).bind(behavior_this_content_on_y)
	var dep$behavior_this_content_on_y$duration$0 = behavior_this_content_on_y._get('parent')._get('parent')
	behavior_this_content_on_y.connectOnChanged(dep$behavior_this_content_on_y$duration$0, 'animationDuration', update$behavior_this_content_on_y$duration)
	behavior_this_content_on_y._replaceUpdater('duration', [[dep$behavior_this_content_on_y$duration$0, 'animationDuration', update$behavior_this_content_on_y$duration]])
	update$behavior_this_content_on_y$duration();

	this$content.setAnimation('y', behavior_this_content_on_y);

	var behavior_this_content_on_x = new _globals.core.Animation(this$content)
	var behavior_this_content_on_x__closure = { behavior_this_content_on_x: behavior_this_content_on_x }

//creating component Animation
	behavior_this_content_on_x.__create(behavior_this_content_on_x__closure.__closure_behavior_this_content_on_x = { })


//setting up component Animation
	var behavior_this_content_on_x = behavior_this_content_on_x__closure.behavior_this_content_on_x
	behavior_this_content_on_x.__setup(behavior_this_content_on_x__closure.__closure_behavior_this_content_on_x)
	delete behavior_this_content_on_x__closure.__closure_behavior_this_content_on_x

//assigning duration to (this._get('parent')._get('parent')._get('animationDuration'))
	var update$behavior_this_content_on_x$duration = (function() { behavior_this_content_on_x.duration = ((this._get('parent')._get('parent')._get('animationDuration'))); }).bind(behavior_this_content_on_x)
	var dep$behavior_this_content_on_x$duration$0 = behavior_this_content_on_x._get('parent')._get('parent')
	behavior_this_content_on_x.connectOnChanged(dep$behavior_this_content_on_x$duration$0, 'animationDuration', update$behavior_this_content_on_x$duration)
	behavior_this_content_on_x._replaceUpdater('duration', [[dep$behavior_this_content_on_x$duration$0, 'animationDuration', update$behavior_this_content_on_x$duration]])
	update$behavior_this_content_on_x$duration();

	this$content.setAnimation('x', behavior_this_content_on_x);

	var behavior_this_content_on_transform = new _globals.core.Animation(this$content)
	var behavior_this_content_on_transform__closure = { behavior_this_content_on_transform: behavior_this_content_on_transform }

//creating component Animation
	behavior_this_content_on_transform.__create(behavior_this_content_on_transform__closure.__closure_behavior_this_content_on_transform = { })


//setting up component Animation
	var behavior_this_content_on_transform = behavior_this_content_on_transform__closure.behavior_this_content_on_transform
	behavior_this_content_on_transform.__setup(behavior_this_content_on_transform__closure.__closure_behavior_this_content_on_transform)
	delete behavior_this_content_on_transform__closure.__closure_behavior_this_content_on_transform

//assigning duration to (this._get('parent')._get('parent')._get('animationDuration'))
	var update$behavior_this_content_on_transform$duration = (function() { behavior_this_content_on_transform.duration = ((this._get('parent')._get('parent')._get('animationDuration'))); }).bind(behavior_this_content_on_transform)
	var dep$behavior_this_content_on_transform$duration$0 = behavior_this_content_on_transform._get('parent')._get('parent')
	behavior_this_content_on_transform.connectOnChanged(dep$behavior_this_content_on_transform$duration$0, 'animationDuration', update$behavior_this_content_on_transform$duration)
	behavior_this_content_on_transform._replaceUpdater('duration', [[dep$behavior_this_content_on_transform$duration$0, 'animationDuration', update$behavior_this_content_on_transform$duration]])
	update$behavior_this_content_on_transform$duration();

	this$content.setAnimation('transform', behavior_this_content_on_transform);

			this._context._onCompleted((function() {
		this._attach()

		var self = this
		this.element.on('scroll', function(event) {
			self._updateScrollPositions(self.element.dom.scrollLeft, self.element.dom.scrollTop)
		}.bind(this))

		this._scheduleLayout()
	} ).bind(this))
}


//=====[component core.ListView]=====================

	var ListViewBaseComponent = _globals.core.BaseView
	var ListViewBasePrototype = ListViewBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.BaseView}
 */
	var ListViewComponent = _globals.core.ListView = function(parent, _delegate) {
		ListViewBaseComponent.apply(this, arguments)

	}
	var ListViewPrototype = ListViewComponent.prototype = Object.create(ListViewBasePrototype)

	ListViewPrototype.constructor = ListViewComponent

	ListViewPrototype.componentName = 'core.ListView'
	ListViewPrototype._updateOverflow = function() {
		if (!this.nativeScrolling)
			return
		var horizontal = this.orientation == this.Horizontal
		var style = {}
		if (horizontal) {
			style['overflow-x'] = 'auto'
			style['overflow-y'] = 'hidden'
		} else {
			style['overflow-x'] = 'hidden'
			style['overflow-y'] = 'auto'
		}
		this.style(style)
	}
	ListViewPrototype.indexAt = function(x,y) {
		var items = this._items
		x += this.contentX
		y += this.contentY
		if (this.orientation == _globals.core.ListView.prototype.Horizontal) {
			for (var i = 0; i < items.length; ++i) {
				var item = items[i]
				if (!item)
					continue
				var vx = item.viewX
				if (x >= vx && x < vx + item.width)
					return i
			}
		} else {
			for (var i = 0; i < items.length; ++i) {
				var item = items[i]
				if (!item)
					continue
				var vy = item.viewY
				if (y >= vy && y < vy + item.height)
					return i
			}
		}
		return -1
	}
	ListViewPrototype._createDelegate = function(idx) {
		var item = _globals.core.BaseView.prototype._createDelegate.apply(this, arguments)
		if (this.orientation === this.Horizontal)
			item.onChanged('width', this._scheduleLayout.bind(this))
		else
			item.onChanged('height', this._scheduleLayout.bind(this))
		return item
	}
	ListViewPrototype.move = function(dx,dy) {
		var horizontal = this.orientation == this.Horizontal
		var x, y
		if (horizontal && this.contentWidth > this.width) {
			x = this.contentX + dx
			if (x < 0)
				x = 0
			else if (x > this.contentWidth - this.width)
				x = this.contentWidth - this.width
			this.contentX = x
		} else if (!horizontal && this.contentHeight > this.height) {
			y = this.contentY + dy
			if (y < 0)
				y = 0
			else if (y > this.contentHeight - this.height)
				y = this.contentHeight - this.height
			this.contentY = y
		}
	}
	ListViewPrototype.positionViewAtIndex = function(idx) {
		if (this.trace)
			log('positionViewAtIndex ' + idx)
		var cx = this.contentX, cy = this.contentY
		var itemBox = this.getItemPosition(idx)
		var x = itemBox[0], y = itemBox[1]
		var iw = itemBox[2], ih = itemBox[3]
		var w = this.width, h = this.height
		var horizontal = this.orientation == this.Horizontal
		var center = this.positionMode === this.Center

		if (horizontal) {
			var atCenter = x - w / 2 + iw / 2
			if (center && this.contentWidth > w)
				this.contentX = atCenter < 0 ? 0 : x > this.contentWidth - w / 2 - iw / 2 ? this.contentWidth - w : atCenter
			else if (iw > w)
				this.contentX = atCenter
			else if (x - cx < 0)
				this.contentX = x
			else if (x - cx + iw > w)
				this.contentX = x + iw - w
		} else {
			var atCenter = y - h / 2 + ih / 2
			if (center && this.contentHeight > h)
				this.contentY = atCenter < 0 ? 0 : y > this.contentHeight - h / 2 - ih / 2 ? this.contentHeight - h : atCenter
			else if (ih > h)
				this.contentY = atCenter
			else if (y - cy < 0)
				this.contentY = y
			else if (y - cy + ih > h)
				this.contentY = y + ih - h
		}
	}
	ListViewPrototype._layout = function() {
		var model = this.model;
		if (!model) {
			this.layoutFinished()
			return
		}

		this.count = model.count

		if (!this.recursiveVisible) {
			this.layoutFinished()
			return
		}

		var horizontal = this.orientation === this.Horizontal

		var items = this._items
		var n = items.length
		var w = this.width, h = this.height
		var created = false
		var p = 0
		var c = horizontal? this.content.x: this.content.y
		var size = horizontal? w: h
		var maxW = 0, maxH = 0

		var itemsCount = 0
		var prerender = this.prerender * size
		var leftMargin = -prerender
		var rightMargin = size + prerender

		if (this.trace)
			log("layout " + n + " into " + w + "x" + h + " @ " + this.content.x + "," + this.content.y + ", prerender: " + prerender + ", range: " + leftMargin + ":" + rightMargin)

		for(var i = 0; i < n && (itemsCount == 0 || p + c < rightMargin); ++i) {
			var item = items[i]

			if (!item) {
				if (p + c >= rightMargin && itemsCount > 0)
					break
				item = this._createDelegate(i)
				created = true
			}

			++itemsCount

			var s = (horizontal? item.width: item.height)
			var visible = (p + c + s >= leftMargin && p + c < rightMargin)

			if (item.x + item.width > maxW)
				maxW = item.width + item.x
			if (item.y + item.height > maxH)
				maxH = item.height + item.y

			if (horizontal)
				item.viewX = p
			else
				item.viewY = p

			if (this.currentIndex == i && !item.focused) {
				this.focusChild(item)
				if (this.contentFollowsCurrentItem)
					this.positionViewAtIndex(i)
			}

			item.visibleInView = visible
			p += s + this.spacing
		}
		for( ;i < n; ++i) {
			var item = items[i]
			if (item)
				item.visibleInView = false
		}
		if (p > 0)
			p -= this.spacing;

		if (itemsCount)
			p *= items.length / itemsCount

		if (this.trace)
			log('result: ' + p + ', max: ' + maxW + 'x' + maxH)
		if (horizontal) {
			this.content.width = p
			this.content.height = maxH
			this.contentWidth = p
			this.contentHeight = maxH
		} else {
			this.content.width = maxW
			this.content.height = p
			this.contentWidth = maxW
			this.contentHeight = p
		}
		this.layoutFinished()
		if (created)
			this._context._complete()
	}
	ListViewPrototype.getItemPosition = function(idx) {
		var items = this._items
		var item = items[idx]
		if (!item) {
			var x = 0, y = 0, w = 0, h = 0
			for(var i = idx; i >= 0; --i) {
				if (items[i]) {
					item = items[i]
					x = item.viewX + item.x
					y = item.viewY + item.y
					w = item.width
					h = item.height
					break
				}
			}
			var missing = idx - i
			if (missing > 0) {
				x += missing * (w + this.spacing)
				y += missing * (h + this.spacing)
			}
			return [x, y, w, h]
		}
		else
			return [item.viewX + item.x, item.viewY + item.y, item.width, item.height]
	}
/** @const @type {number} */
	ListViewPrototype.Vertical = 0
/** @const @type {number} */
	ListViewComponent.Vertical = 0
/** @const @type {number} */
	ListViewPrototype.Horizontal = 1
/** @const @type {number} */
	ListViewComponent.Horizontal = 1
	core.addProperty(ListViewPrototype, 'enum', 'orientation')
	_globals.core._protoOnChanged(ListViewPrototype, 'orientation', (function(value) {
		this._updateOverflow()
		this._scheduleLayout()
	} ))
	_globals.core._protoOnKey(ListViewPrototype, 'Key', (function(key, event) {
		if (!this.handleNavigationKeys) {
			event.accepted = false;
			return false;
		}

		var horizontal = this.orientation == this.Horizontal
		if (horizontal) {
			if (key == 'Left') {
				--this.currentIndex;
				event.accepted = true;
				return true;
			} else if (key == 'Right') {
				++this.currentIndex;
				event.accepted = true;
				return true;
			}
		} else {
			if (key == 'Up') {
				if (!this.currentIndex && !this.keyNavigationWraps) {
					event.accepted = false;
					return false;
				}
				--this.currentIndex;
				return true;
			} else if (key == 'Down') {
				if (this.currentIndex == this.count - 1 && !this.keyNavigationWraps) {
					event.accepted = false;
					return false;
				}
				++this.currentIndex;
				event.accepted = true;
				return true;
			}
		}
	} ))

	ListViewPrototype.__create = function(__closure) {
		ListViewBasePrototype.__create.call(this, __closure.__base = { })

	}
	ListViewPrototype.__setup = function(__closure) {
	ListViewBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
this._context._onCompleted((function() {
		this._updateOverflow()
	} ).bind(this))
}


//=====[component core.Rectangle]=====================

	var RectangleBaseComponent = _globals.core.Item
	var RectangleBasePrototype = RectangleBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var RectangleComponent = _globals.core.Rectangle = function(parent, _delegate) {
		RectangleBaseComponent.apply(this, arguments)

	}
	var RectanglePrototype = RectangleComponent.prototype = Object.create(RectangleBasePrototype)

	RectanglePrototype.constructor = RectangleComponent

	RectanglePrototype.componentName = 'core.Rectangle'
	RectanglePrototype._mapCSSAttribute = function(name) {
		var attr = {color: 'background-color'}[name]
		return (attr !== undefined)?
			attr:
			_globals.core.Item.prototype._mapCSSAttribute.apply(this, arguments)
	}
	core.addProperty(RectanglePrototype, 'color', 'color', ("#0000"))
	core.addLazyProperty(RectanglePrototype, 'border', (function(__parent) {
		var lazy$border = new _globals.core.Border(__parent, true)
		var __closure = { lazy$border : lazy$border }

//creating component Border
			lazy$border.__create(__closure.__closure_lazy$border = { })


//setting up component Border
			var lazy$border = __closure.lazy$border
			lazy$border.__setup(__closure.__closure_lazy$border)
			delete __closure.__closure_lazy$border



		return lazy$border
}))
	core.addProperty(RectanglePrototype, 'Gradient', 'gradient')
	_globals.core._protoOnChanged(RectanglePrototype, 'color', (function(value) { this.style('background-color', _globals.core.normalizeColor(value)) } ))

//=====[component src.ToolbarButton]=====================

	var ToolbarButtonBaseComponent = _globals.core.Rectangle
	var ToolbarButtonBasePrototype = ToolbarButtonBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Rectangle}
 */
	var ToolbarButtonComponent = _globals.src.ToolbarButton = function(parent, _delegate) {
		ToolbarButtonBaseComponent.apply(this, arguments)

	}
	var ToolbarButtonPrototype = ToolbarButtonComponent.prototype = Object.create(ToolbarButtonBasePrototype)

	ToolbarButtonPrototype.constructor = ToolbarButtonComponent

	ToolbarButtonPrototype.componentName = 'src.ToolbarButton'
	ToolbarButtonPrototype.clicked = _globals.core.createSignal('clicked')

	ToolbarButtonPrototype.__create = function(__closure) {
		ToolbarButtonBasePrototype.__create.call(this, __closure.__base = { })
var this$child0 = new _globals.core.Image(this)
		__closure.this$child0 = this$child0

//creating component Image
		this$child0.__create(__closure.__closure_this$child0 = { })
		this$child0._setId('icon')
		var this$child1 = new _globals.core.MouseArea(this)
		__closure.this$child1 = this$child1

//creating component MouseArea
		this$child1.__create(__closure.__closure_this$child1 = { })

		this._setId('container')
		core.addAliasProperty(this, 'background', (function() { return this._get('container'); }).bind(this), 'color')
		core.addAliasProperty(this, 'icon', (function() { return this._get('icon'); }).bind(this), 'source')
	}
	ToolbarButtonPrototype.__setup = function(__closure) {
	ToolbarButtonBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//assigning width to (50)
			this._replaceUpdater('width'); this.width = ((50));
//assigning radius to (this._get('width') / 2)
			var update$this$radius = (function() { this.radius = ((this._get('width') / 2)); }).bind(this)
			var dep$this$radius$0 = this
			this.connectOnChanged(dep$this$radius$0, 'width', update$this$radius)
			this._replaceUpdater('radius', [[dep$this$radius$0, 'width', update$this$radius]])
			update$this$radius();
//assigning height to (50)
			this._replaceUpdater('height'); this.height = ((50));


//setting up component Image
			var this$child0 = __closure.this$child0
			this$child0.__setup(__closure.__closure_this$child0)
			delete __closure.__closure_this$child0

//assigning fillMode to (_globals.core.Image.prototype.PreserveAspectFit)
			this$child0._replaceUpdater('fillMode'); this$child0.fillMode = ((_globals.core.Image.prototype.PreserveAspectFit));
//assigning source to ("./icons/help-white.png")
			this$child0._replaceUpdater('source'); this$child0.source = (("./icons/help-white.png"));
//assigning anchors.margins to (8)
			this$child0._replaceUpdater('anchors.margins'); this$child0._get('anchors').margins = ((8));
//assigning anchors.fill to (this._get('parent'))
			var update$this_child0$anchors_fill = (function() { this$child0._get('anchors').fill = ((this._get('parent'))); }).bind(this$child0)
			var dep$this_child0$anchors_fill$0 = this$child0
			this$child0.connectOnChanged(dep$this_child0$anchors_fill$0, 'parent', update$this_child0$anchors_fill)
			this$child0._replaceUpdater('anchors.fill', [[dep$this_child0$anchors_fill$0, 'parent', update$this_child0$anchors_fill]])
			update$this_child0$anchors_fill();

			this.addChild(this$child0)

//setting up component MouseArea
			var this$child1 = __closure.this$child1
			this$child1.__setup(__closure.__closure_this$child1)
			delete __closure.__closure_this$child1

//assigning anchors.fill to (this._get('parent'))
			var update$this_child1$anchors_fill = (function() { this$child1._get('anchors').fill = ((this._get('parent'))); }).bind(this$child1)
			var dep$this_child1$anchors_fill$0 = this$child1
			this$child1.connectOnChanged(dep$this_child1$anchors_fill$0, 'parent', update$this_child1$anchors_fill)
			this$child1._replaceUpdater('anchors.fill', [[dep$this_child1$anchors_fill$0, 'parent', update$this_child1$anchors_fill]])
			update$this_child1$anchors_fill();
			this$child1.on('clicked', (function() {
            parent.clicked();
        } ).bind(this$child1))

			this.addChild(this$child1)
}


//=====[component core.Border]=====================

	var BorderBaseComponent = _globals.core.Object
	var BorderBasePrototype = BorderBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var BorderComponent = _globals.core.Border = function(parent, _delegate) {
		BorderBaseComponent.apply(this, arguments)

	}
	var BorderPrototype = BorderComponent.prototype = Object.create(BorderBasePrototype)

	BorderPrototype.constructor = BorderComponent

	BorderPrototype.componentName = 'core.Border'
	core.addProperty(BorderPrototype, 'int', 'width')
	core.addProperty(BorderPrototype, 'color', 'color')
	core.addProperty(BorderPrototype, 'string', 'style')
	core.addProperty(BorderPrototype, 'BorderSide', 'left')
	core.addProperty(BorderPrototype, 'BorderSide', 'right')
	core.addProperty(BorderPrototype, 'BorderSide', 'top')
	core.addProperty(BorderPrototype, 'BorderSide', 'bottom')
	_globals.core._protoOnChanged(BorderPrototype, 'width', (function(value) { this.parent.style({'border-width': value, 'margin-left': -value, 'margin-top': -value}) } ))
	_globals.core._protoOnChanged(BorderPrototype, 'color', (function(value) { this.parent.style('border-color', _globals.core.normalizeColor(value)) } ))
	_globals.core._protoOnChanged(BorderPrototype, 'style', (function(value) { this.parent.style('border-style', value) } ))

	BorderPrototype.__create = function(__closure) {
		BorderBasePrototype.__create.call(this, __closure.__base = { })
//creating component core.<anonymous>
		var this$top = new _globals.core.BorderSide(this)
		__closure.this$top = this$top

//creating component BorderSide
		this$top.__create(__closure.__closure_this$top = { })

		this.top = this$top
//creating component core.<anonymous>
		var this$right = new _globals.core.BorderSide(this)
		__closure.this$right = this$right

//creating component BorderSide
		this$right.__create(__closure.__closure_this$right = { })

		this.right = this$right
//creating component core.<anonymous>
		var this$bottom = new _globals.core.BorderSide(this)
		__closure.this$bottom = this$bottom

//creating component BorderSide
		this$bottom.__create(__closure.__closure_this$bottom = { })

		this.bottom = this$bottom
//creating component core.<anonymous>
		var this$left = new _globals.core.BorderSide(this)
		__closure.this$left = this$left

//creating component BorderSide
		this$left.__create(__closure.__closure_this$left = { })

		this.left = this$left
	}
	BorderPrototype.__setup = function(__closure) {
	BorderBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//setting up component BorderSide
			var this$top = __closure.this$top
			this$top.__setup(__closure.__closure_this$top)
			delete __closure.__closure_this$top

//assigning name to ("top")
			this$top._replaceUpdater('name'); this$top.name = (("top"));


//setting up component BorderSide
			var this$right = __closure.this$right
			this$right.__setup(__closure.__closure_this$right)
			delete __closure.__closure_this$right

//assigning name to ("right")
			this$right._replaceUpdater('name'); this$right.name = (("right"));


//setting up component BorderSide
			var this$bottom = __closure.this$bottom
			this$bottom.__setup(__closure.__closure_this$bottom)
			delete __closure.__closure_this$bottom

//assigning name to ("bottom")
			this$bottom._replaceUpdater('name'); this$bottom.name = (("bottom"));


//setting up component BorderSide
			var this$left = __closure.this$left
			this$left.__setup(__closure.__closure_this$left)
			delete __closure.__closure_this$left

//assigning name to ("left")
			this$left._replaceUpdater('name'); this$left.name = (("left"));
}


//=====[component core.BorderSide]=====================

	var BorderSideBaseComponent = _globals.core.Object
	var BorderSideBasePrototype = BorderSideBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var BorderSideComponent = _globals.core.BorderSide = function(parent, _delegate) {
		BorderSideBaseComponent.apply(this, arguments)

	}
	var BorderSidePrototype = BorderSideComponent.prototype = Object.create(BorderSideBasePrototype)

	BorderSidePrototype.constructor = BorderSideComponent

	BorderSidePrototype.componentName = 'core.BorderSide'
	BorderSidePrototype._updateStyle = function() {
		if (this.parent && this.parent.parent) {
			var pp = this.parent.parent
			if (pp) {
				var cssname = 'border-' + this.name
				if (this.width) {
					pp.style(cssname, this.width + "px solid " + _globals.core.normalizeColor(this.color))
				} else
					pp.style(cssname, '')
			}
		}
	}
	core.addProperty(BorderSidePrototype, 'string', 'name')
	core.addProperty(BorderSidePrototype, 'int', 'width')
	core.addProperty(BorderSidePrototype, 'color', 'color')
	_globals.core._protoOnChanged(BorderSidePrototype, 'width', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(BorderSidePrototype, 'color', (function(value) { this._updateStyle() } ))

//=====[component core.Effects]=====================

	var EffectsBaseComponent = _globals.core.Object
	var EffectsBasePrototype = EffectsBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var EffectsComponent = _globals.core.Effects = function(parent, _delegate) {
		EffectsBaseComponent.apply(this, arguments)

	}
	var EffectsPrototype = EffectsComponent.prototype = Object.create(EffectsBasePrototype)

	EffectsPrototype.constructor = EffectsComponent

	EffectsPrototype.componentName = 'core.Effects'
	EffectsPrototype._getFilterStyle = function() {
		var style = []
		this._addStyle(style, 'blur', 'blur', 'px')
		this._addStyle(style, 'grayscale')
		this._addStyle(style, 'sepia')
		this._addStyle(style, 'brightness')
		this._addStyle(style, 'contrast')
		this._addStyle(style, 'hueRotate', 'hue-rotate', 'deg')
		this._addStyle(style, 'invert')
		this._addStyle(style, 'saturate')
		return style
	}
	EffectsPrototype._addStyle = function(array,property,style,units) {
		var value = this[property]
		if (value)
			array.push((style || property) + '(' + value + (units || '') + ') ')
	}
	EffectsPrototype._updateStyle = function(updateShadow) {
		var filterStyle = this._getFilterStyle().join('')
		var parent = this.parent

		var style = {}
		var updateStyle = false

		if (filterStyle.length > 0) {
			//chromium bug
			//https://github.com/Modernizr/Modernizr/issues/981
			style['-webkit-filter'] = filterStyle
			style['filter'] = filterStyle
			updateStyle = true
		}

		if (this.shadow && (!this.shadow._empty() || updateShadow)) {
			style['box-shadow'] = this.shadow._getFilterStyle()
			updateStyle = true
		}

		if (updateStyle) {
			//log(style)
			parent.style(style)
		}
	}
	core.addProperty(EffectsPrototype, 'real', 'blur')
	core.addProperty(EffectsPrototype, 'real', 'grayscale')
	core.addProperty(EffectsPrototype, 'real', 'sepia')
	core.addProperty(EffectsPrototype, 'real', 'brightness')
	core.addProperty(EffectsPrototype, 'real', 'contrast')
	core.addProperty(EffectsPrototype, 'real', 'hueRotate')
	core.addProperty(EffectsPrototype, 'real', 'invert')
	core.addProperty(EffectsPrototype, 'real', 'saturate')
	core.addLazyProperty(EffectsPrototype, 'shadow', (function(__parent) {
		var lazy$shadow = new _globals.core.Shadow(__parent, true)
		var __closure = { lazy$shadow : lazy$shadow }

//creating component Shadow
			lazy$shadow.__create(__closure.__closure_lazy$shadow = { })


//setting up component Shadow
			var lazy$shadow = __closure.lazy$shadow
			lazy$shadow.__setup(__closure.__closure_lazy$shadow)
			delete __closure.__closure_lazy$shadow



		return lazy$shadow
}))
	_globals.core._protoOnChanged(EffectsPrototype, 'saturate', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'brightness', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'grayscale', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'sepia', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'invert', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'hueRotate', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'contrast', (function(value) { this._updateStyle() } ))
	_globals.core._protoOnChanged(EffectsPrototype, 'blur', (function(value) { this._updateStyle() } ))

//=====[component core.Font]=====================

	var FontBaseComponent = _globals.core.Object
	var FontBasePrototype = FontBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var FontComponent = _globals.core.Font = function(parent, _delegate) {
		FontBaseComponent.apply(this, arguments)

	}
	var FontPrototype = FontComponent.prototype = Object.create(FontBasePrototype)

	FontPrototype.constructor = FontComponent

	FontPrototype.componentName = 'core.Font'
	core.addProperty(FontPrototype, 'string', 'family')
	core.addProperty(FontPrototype, 'bool', 'italic')
	core.addProperty(FontPrototype, 'bool', 'bold')
	core.addProperty(FontPrototype, 'bool', 'underline')
	core.addProperty(FontPrototype, 'bool', 'strike')
	core.addProperty(FontPrototype, 'real', 'letterSpacing')
	core.addProperty(FontPrototype, 'int', 'pixelSize')
	core.addProperty(FontPrototype, 'int', 'pointSize')
	core.addProperty(FontPrototype, 'int', 'lineHeight')
	core.addProperty(FontPrototype, 'int', 'weight')
	_globals.core._protoOnChanged(FontPrototype, 'italic', (function(value) { this.parent.style('font-style', value? 'italic': 'normal'); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'pixelSize', (function(value) { this.parent.style('font-size', value + "px"); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'family', (function(value) { this.parent.style('font-family', value); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'lineHeight', (function(value) { this.parent.style('line-height', value + "px"); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'strike', (function(value) { this.parent.style('text-decoration', value? 'line-through': ''); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'weight', (function(value) { this.parent.style('font-weight', value); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'bold', (function(value) { this.parent.style('font-weight', value? 'bold': 'normal'); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'pointSize', (function(value) { this.parent.style('font-size', value + "pt"); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'letterSpacing', (function(value) { this.parent.style('letter-spacing', value + "px"); this.parent._updateSize() } ))
	_globals.core._protoOnChanged(FontPrototype, 'underline', (function(value) { this.parent.style('text-decoration', value? 'underline': ''); this.parent._updateSize() } ))

//=====[component core.MouseArea]=====================

	var MouseAreaBaseComponent = _globals.core.Item
	var MouseAreaBasePrototype = MouseAreaBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var MouseAreaComponent = _globals.core.MouseArea = function(parent, _delegate) {
		MouseAreaBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._bindClick(this.clickable)
		this._bindWheel(this.wheelEnabled)
		this._bindPressable(this.pressable)
		this._bindHover(this.hoverEnabled)
		this._bindTouch(this.touchEnabled)
	}

	}
	var MouseAreaPrototype = MouseAreaComponent.prototype = Object.create(MouseAreaBasePrototype)

	MouseAreaPrototype.constructor = MouseAreaComponent

	MouseAreaPrototype.componentName = 'core.MouseArea'
	MouseAreaPrototype.clicked = _globals.core.createSignal('clicked')
	MouseAreaPrototype.touchStart = _globals.core.createSignal('touchStart')
	MouseAreaPrototype.verticalSwiped = _globals.core.createSignal('verticalSwiped')
	MouseAreaPrototype.horizontalSwiped = _globals.core.createSignal('horizontalSwiped')
	MouseAreaPrototype.mouseMove = _globals.core.createSignal('mouseMove')
	MouseAreaPrototype.canceled = _globals.core.createSignal('canceled')
	MouseAreaPrototype.touchMove = _globals.core.createSignal('touchMove')
	MouseAreaPrototype.wheelEvent = _globals.core.createSignal('wheelEvent')
	MouseAreaPrototype.touchEnd = _globals.core.createSignal('touchEnd')
	MouseAreaPrototype.entered = _globals.core.createSignal('entered')
	MouseAreaPrototype.exited = _globals.core.createSignal('exited')
	MouseAreaPrototype._bindTouch = function(value) {
		if (value && !this._touchBinder) {
			this._touchBinder = new _globals.core.EventBinder(this.element)

			var touchStart = function(event) { this.touchStart(event) }.bind(this)
			var touchEnd = function(event) { this.touchEnd(event) }.bind(this)
			var touchMove = (function(event) { this.touchMove(event) }).bind(this)

			if ('ontouchstart' in window)
				this._touchBinder.on('touchstart', touchStart)
			if ('ontouchend' in window)
				this._touchBinder.on('touchend', touchEnd)
			if ('ontouchmove' in window)
				this._touchBinder.on('touchmove', touchMove)
		}
		if (this._touchBinder)
			this._touchBinder.enable(value)
	}
	MouseAreaPrototype._bindClick = function(value) {
		if (value && !this._clickBinder) {
			this._clickBinder = new _globals.core.EventBinder(this.element)
			this._clickBinder.on('click', this.clicked.bind(this))
		}
		if (this._clickBinder)
			this._clickBinder.enable(value)
	}
	MouseAreaPrototype._bindPressable = function(value) {
		if (value && !this._pressableBinder) {
			this._pressableBinder = new _globals.core.EventBinder(this.element)
			this._pressableBinder.on('mousedown', function()	{ this.pressed = true }.bind(this))
			this._pressableBinder.on('mouseup', function()		{ this.pressed = false }.bind(this))
		}
		if (this._pressableBinder)
			this._pressableBinder.enable(value)
	}
	MouseAreaPrototype._bindWheel = function(value) {
		if (value && !this._wheelBinder) {
			this._clickBinder = new _globals.core.EventBinder(this.element)
			this._clickBinder.on('mousewheel', function(event) { this.wheelEvent(event.wheelDelta / 120) }.bind(this))
		}
		if (this._clickBinder)
			this._clickBinder.enable(value)
	}
	MouseAreaPrototype._bindHover = function(value) {
		if (value && !this._hoverBinder) {
			this._hoverBinder = new _globals.core.EventBinder(this.element)
			this._hoverBinder.on('mouseenter', function() { this.hover = true }.bind(this))
			this._hoverBinder.on('mouseleave', function() { this.hover = false }.bind(this))
			this._hoverBinder.on('mousemove', function(event) { if (this.updatePosition(event)) event.preventDefault() }.bind(this))
		}
		if (this._hoverBinder)
			this._hoverBinder.enable(value)
	}
	MouseAreaPrototype.updatePosition = function(event) {
		if (!this.recursiveVisible)
			return false

		var box = this.toScreen()
		var x = event.clientX - box[0]
		var y = event.clientY - box[1]

		if (x >= 0 && y >= 0 && x < this.width && y < this.height) {
			this.mouseX = x
			this.mouseY = y
			this.mouseMove()
			return true
		}
		else
			return false
	}
	core.addProperty(MouseAreaPrototype, 'real', 'mouseX')
	core.addProperty(MouseAreaPrototype, 'real', 'mouseY')
	core.addProperty(MouseAreaPrototype, 'string', 'cursor')
	core.addProperty(MouseAreaPrototype, 'bool', 'pressed')
	core.addProperty(MouseAreaPrototype, 'bool', 'containsMouse')
	core.addProperty(MouseAreaPrototype, 'bool', 'clickable', (true))
	core.addProperty(MouseAreaPrototype, 'bool', 'pressable', (true))
	core.addProperty(MouseAreaPrototype, 'bool', 'touchEnabled', (true))
	core.addProperty(MouseAreaPrototype, 'bool', 'hoverEnabled', (true))
	core.addProperty(MouseAreaPrototype, 'bool', 'wheelEnabled', (true))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'wheelEnabled', (function(value) {
		this._bindWheel(value)
	} ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'hoverEnabled', (function(value) {
		this._bindHover(value)
	} ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'touchEnabled', (function(value) {
		this._bindTouch(value)
	} ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'recursiveVisible', (function(value) {
		if (!value)
			this.containsMouse = false
	} ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'clickable', (function(value) {
		this._bindClick(value)
	} ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'cursor', (function(value) { this.style('cursor', value) } ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'pressable', (function(value) {
		this._bindPressable(value)
	} ))
	_globals.core._protoOnChanged(MouseAreaPrototype, 'containsMouse', (function(value) {
		if (this.containsMouse) {
			this.entered()
		} else if (!this.containsMouse && this.pressable && this.pressed) {
			this.pressed = false
			this.canceled()
		} else {
			this.exited()
		}
	} ))
	_globals.core._protoOn(MouseAreaPrototype, 'touchMove', (function(event) {
		var box = this.toScreen()
		var e = event.touches[0]
		var x = e.pageX - box[0]
		var y = e.pageY - box[1]
		var dx = x - this._startX
		var dy = y - this._startY
		var adx = Math.abs(dx)
		var ady = Math.abs(dy)
		var motion = adx > 5 || ady > 5
		if (!motion)
			return

		if (!this._orientation)
			this._orientation = adx > ady ? 'horizontal' : 'vertical'

		// for delegated events, the target may change over time
		// this ensures we notify the right target and simulates the mouseleave behavior
		while (event.target && event.target !== this._startTarget)
			event.target = event.target.parentNode;
		if (event.target !== this._startTarget) {
			event.target = this._startTarget;
			return;
		}

		if (this._orientation == 'horizontal')
			this.horizontalSwiped(event)
		else
			this.verticalSwiped(event)
	} ))
	_globals.core._protoOn(MouseAreaPrototype, 'touchStart', (function(event) {
		var box = this.toScreen()
		var e = event.touches[0]
		var x = e.pageX - box[0]
		var y = e.pageY - box[1]
		this._startX = x
		this._startY = y
		this._orientation = null;
		this._startTarget = event.target;
	} ))

	MouseAreaPrototype.__create = function(__closure) {
		MouseAreaBasePrototype.__create.call(this, __closure.__base = { })
core.addAliasProperty(this, 'hover', (function() { return this; }).bind(this), 'containsMouse')
		core.addAliasProperty(this, 'hoverable', (function() { return this; }).bind(this), 'hoverEnabled')
	}
	MouseAreaPrototype.__setup = function(__closure) {
	MouseAreaBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base

}


//=====[component core.Context]=====================

	var ContextBaseComponent = _globals.core.Item
	var ContextBasePrototype = ContextBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var ContextComponent = _globals.core.Context = function(parent, _delegate) {
		ContextBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this.options = arguments[2]
		this.l10n = this.options.l10n || {}

		this._local['context'] = this
		this._prefix = this.options.prefix
		this._context = this
		this._started = false
		this._completed = false
		this._processingActions = false
		this._delayedActions = []
		this._stylesRegistered = {}

		this.backend = _globals._backend()
	}

	}
	var ContextPrototype = ContextComponent.prototype = Object.create(ContextBasePrototype)

	ContextPrototype.constructor = ContextComponent

	ContextPrototype.componentName = 'core.Context'
	ContextPrototype.start = function(instance) {
		var closure = {}
		this.children.push(instance)
		instance.__create(closure)
		instance.__setup(closure)
		closure = undefined
		log('Context: created instance')
		this._started = true
		// log('Context: calling on completed')
		return instance;
	}
	ContextPrototype.createElement = function(tag) {
		var el = this.backend.createElement(this, tag)
		if (this._prefix) {
			el.addClass(this.getClass('core-item'))
		}
		return el
	}
	ContextPrototype.scheduleAction = function(action) {
		this._delayedActions.push(action)
	}
	ContextPrototype.getClass = function(name) {
		return this._prefix + name
	}
	ContextPrototype.init = function() {
		log('Context: initializing...')
		new this.backend.init(this)
		var invoker = _globals.core.safeCall(null, [], function (ex) { log("prototype constructor failed:", ex, ex.stack) })
		__prototype$ctors.forEach(invoker)
		__prototype$ctors = undefined
	}
	ContextPrototype._onCompleted = function(callback) {
		this.scheduleAction(callback)
	}
	ContextPrototype._run = function() {
		log('Context: signalling layout')
		this.visibleInView = true
		this.boxChanged()
		log('Context: calling completed()')
		this._complete()
		this._completed = true
		this._processActions()
	}
	ContextPrototype.delayedAction = function(prefix,self,method) {
		var name = '__delayed_' + prefix
		if (self[name] === true)
			return

		self[name] = true
		this.scheduleAction(function() {
			method.call(self)
			self[name] = false
		})
	}
	ContextPrototype.qsTr = function(text) {
		var args = arguments
		var lang = this.language
		var messages = this.l10n[lang] || {}
		var contexts = messages[text] || {}
		for(var name in contexts) {
			text = contexts[name] //fixme: add context handling here
			break
		}
		return text.replace(/%(\d+)/, function(text, index) { return args[index] })
	}
	ContextPrototype.run = function() {
		this.backend.run(this, this._run.bind(this))
	}
	ContextPrototype.registerStyle = function(item,tag) {
		if (!(tag in this._stylesRegistered)) {
			item.registerStyle(this.stylesheet, tag)
			this._stylesRegistered[tag] = true
		}
	}
	ContextPrototype._complete = function() {
		this._processActions()
	}
	ContextPrototype._processActions = function() {
		if (!this._started || this._processingActions)
			return

		this._processingActions = true

		var invoker = _globals.core.safeCall(this, [], function (ex) { log("async action failed:", ex, ex.stack) })
		while (this._delayedActions.length) {
			var actions = this._delayedActions
			this._delayedActions = []
			actions.forEach(invoker)
		}

		this._processingActions = false
		this._delayedTimeout = undefined
	}
	core.addProperty(ContextPrototype, 'int', 'scrollY')
	core.addProperty(ContextPrototype, 'bool', 'fullscreen')
	core.addProperty(ContextPrototype, 'string', 'language')
	core.addProperty(ContextPrototype, 'System', 'system')
	core.addProperty(ContextPrototype, 'Location', 'location')
	core.addProperty(ContextPrototype, 'Stylesheet', 'stylesheet')
	core.addProperty(ContextPrototype, 'Orientation', 'orientation')
	core.addProperty(ContextPrototype, 'string', 'buildIdentifier', "Powered by PureQML No-Partnership Edition Engine")
	_globals.core._protoOnChanged(ContextPrototype, 'fullscreen', (function(value) { if (value) this.backend.enterFullscreenMode(this.element); else this.backend.exitFullscreenMode(); } ))

	ContextPrototype.__create = function(__closure) {
		ContextBasePrototype.__create.call(this, __closure.__base = { })
//creating component core.<anonymous>
		var this$orientation = new _globals.html5.Orientation(this)
		__closure.this$orientation = this$orientation

//creating component Orientation
		this$orientation.__create(__closure.__closure_this$orientation = { })

		this.orientation = this$orientation
//creating component core.<anonymous>
		var this$stylesheet = new _globals.html5.Stylesheet(this)
		__closure.this$stylesheet = this$stylesheet

//creating component Stylesheet
		this$stylesheet.__create(__closure.__closure_this$stylesheet = { })

		this.stylesheet = this$stylesheet
//creating component core.<anonymous>
		var this$system = new _globals.core.System(this)
		__closure.this$system = this$system

//creating component System
		this$system.__create(__closure.__closure_this$system = { })

		this.system = this$system
//creating component core.<anonymous>
		var this$location = new _globals.html5.Location(this)
		__closure.this$location = this$location

//creating component Location
		this$location.__create(__closure.__closure_this$location = { })

		this.location = this$location
	}
	ContextPrototype.__setup = function(__closure) {
	ContextBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//setting up component Orientation
			var this$orientation = __closure.this$orientation
			this$orientation.__setup(__closure.__closure_this$orientation)
			delete __closure.__closure_this$orientation



//setting up component Stylesheet
			var this$stylesheet = __closure.this$stylesheet
			this$stylesheet.__setup(__closure.__closure_this$stylesheet)
			delete __closure.__closure_this$stylesheet



//setting up component System
			var this$system = __closure.this$system
			this$system.__setup(__closure.__closure_this$system)
			delete __closure.__closure_this$system


//assigning visibleInView to (false)
			this._replaceUpdater('visibleInView'); this.visibleInView = ((false));

//setting up component Location
			var this$location = __closure.this$location
			this$location.__setup(__closure.__closure_this$location)
			delete __closure.__closure_this$location
}


//=====[component core.Text]=====================

	var TextBaseComponent = _globals.core.Item
	var TextBasePrototype = TextBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var TextComponent = _globals.core.Text = function(parent, _delegate) {
		TextBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._context.backend.initText(this)
		this._setText(this.text)
	}

	}
	var TextPrototype = TextComponent.prototype = Object.create(TextBasePrototype)

	TextPrototype.constructor = TextComponent

	TextPrototype.componentName = 'core.Text'
	TextPrototype.on = function(name,callback) {
		if (!this._updateSizeNeeded) {
			if (name == 'boxChanged')
				this._enableSizeUpdate()
		}
		_globals.core.Object.prototype.on.apply(this, arguments)
	}
	TextPrototype.onChanged = function(name,callback) {
		if (!this._updateSizeNeeded) {
			switch(name) {
				case "right":
				case "width":
				case "bottom":
				case "height":
				case "verticalCenter":
				case "horizontalCenter":
					this._enableSizeUpdate()
			}
		}
		_globals.core.Object.prototype.onChanged.apply(this, arguments);
	}
	TextPrototype._enableSizeUpdate = function() {
		this._updateSizeNeeded = true
		this._updateSize()
	}
	TextPrototype._scheduleUpdateSize = function() {
		this._context.delayedAction('text:update-size', this, this._updateSizeImpl)
	}
	TextPrototype._setText = function(html) {
		this._context.backend.setText(this, html)
	}
	TextPrototype._updateSizeImpl = function() {
		if (this.text.length === 0) {
			this.paintedWidth = 0
			this.paintedHeight = 0
			return
		}

		this._context.backend.layoutText(this)
	}
	TextPrototype._updateStyle = function() {
		if (this.shadow && !this.shadow._empty())
			this.style('text-shadow', this.shadow._getFilterStyle())
		else
			this.style('text-shadow', '')
		_globals.core.Item.prototype._updateStyle.apply(this, arguments)
	}
	TextPrototype._updateSize = function() {
		if (this.recursiveVisible && (this._updateSizeNeeded || this.clip))
			this._scheduleUpdateSize()
	}
	core.addProperty(TextPrototype, 'string', 'text')
	core.addProperty(TextPrototype, 'color', 'color')
	core.addLazyProperty(TextPrototype, 'shadow', (function(__parent) {
		var lazy$shadow = new _globals.core.Shadow(__parent, true)
		var __closure = { lazy$shadow : lazy$shadow }

//creating component Shadow
			lazy$shadow.__create(__closure.__closure_lazy$shadow = { })


//setting up component Shadow
			var lazy$shadow = __closure.lazy$shadow
			lazy$shadow.__setup(__closure.__closure_lazy$shadow)
			delete __closure.__closure_lazy$shadow



		return lazy$shadow
}))
	core.addLazyProperty(TextPrototype, 'font', (function(__parent) {
		var lazy$font = new _globals.core.Font(__parent, true)
		var __closure = { lazy$font : lazy$font }

//creating component Font
			lazy$font.__create(__closure.__closure_lazy$font = { })


//setting up component Font
			var lazy$font = __closure.lazy$font
			lazy$font.__setup(__closure.__closure_lazy$font)
			delete __closure.__closure_lazy$font



		return lazy$font
}))
	core.addProperty(TextPrototype, 'int', 'paintedWidth')
	core.addProperty(TextPrototype, 'int', 'paintedHeight')
/** @const @type {number} */
	TextPrototype.AlignTop = 0
/** @const @type {number} */
	TextComponent.AlignTop = 0
/** @const @type {number} */
	TextPrototype.AlignBottom = 1
/** @const @type {number} */
	TextComponent.AlignBottom = 1
/** @const @type {number} */
	TextPrototype.AlignVCenter = 2
/** @const @type {number} */
	TextComponent.AlignVCenter = 2
	core.addProperty(TextPrototype, 'enum', 'verticalAlignment')
/** @const @type {number} */
	TextPrototype.AlignLeft = 0
/** @const @type {number} */
	TextComponent.AlignLeft = 0
/** @const @type {number} */
	TextPrototype.AlignRight = 1
/** @const @type {number} */
	TextComponent.AlignRight = 1
/** @const @type {number} */
	TextPrototype.AlignHCenter = 2
/** @const @type {number} */
	TextComponent.AlignHCenter = 2
/** @const @type {number} */
	TextPrototype.AlignJustify = 3
/** @const @type {number} */
	TextComponent.AlignJustify = 3
	core.addProperty(TextPrototype, 'enum', 'horizontalAlignment')
/** @const @type {number} */
	TextPrototype.NoWrap = 0
/** @const @type {number} */
	TextComponent.NoWrap = 0
/** @const @type {number} */
	TextPrototype.WordWrap = 1
/** @const @type {number} */
	TextComponent.WordWrap = 1
/** @const @type {number} */
	TextPrototype.WrapAnywhere = 2
/** @const @type {number} */
	TextComponent.WrapAnywhere = 2
/** @const @type {number} */
	TextPrototype.Wrap = 3
/** @const @type {number} */
	TextComponent.Wrap = 3
	core.addProperty(TextPrototype, 'enum', 'wrapMode')
	_globals.core._protoOnChanged(TextPrototype, 'wrapMode', (function(value) {
		switch(value) {
		case this.NoWrap:
			this.style({'white-space': 'nowrap', 'word-break': '' })
			break
		case this.Wrap:
		case this.WordWrap:
			this.style({'white-space': 'normal', 'word-break': '' })
			break
		case this.WrapAnywhere:
			this.style({ 'white-space': 'normal', 'word-break': 'break-all' })
			break
		}
		this._updateSize();
	} ))
	_globals.core._protoOnChanged(TextPrototype, 'verticalAlignment', (function(value) {
		this.verticalAlignment = value;
		this._enableSizeUpdate()
	} ))
	_globals.core._protoOnChanged(TextPrototype, 'horizontalAlignment', (function(value) {
		switch(value) {
		case this.AlignLeft:	this.style('text-align', 'left'); break
		case this.AlignRight:	this.style('text-align', 'right'); break
		case this.AlignHCenter:	this.style('text-align', 'center'); break
		case this.AlignJustify:	this.style('text-align', 'justify'); break
		}
	} ))
	_globals.core._protoOnChanged(TextPrototype, 'recursiveVisible', (function(value) {
		if (value)
			this._updateSize()
	} ))
	_globals.core._protoOnChanged(TextPrototype, 'width', (function(value) { this._updateSize() } ))
	_globals.core._protoOnChanged(TextPrototype, 'text', (function(value) { this._setText(value); this._updateSize() } ))
	_globals.core._protoOnChanged(TextPrototype, 'color', (function(value) { this.style('color', _globals.core.normalizeColor(value)) } ))

	TextPrototype.__create = function(__closure) {
		TextBasePrototype.__create.call(this, __closure.__base = { })

	}
	TextPrototype.__setup = function(__closure) {
	TextBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
//assigning width to (this._get('paintedWidth'))
			var update$this$width = (function() { this.width = ((this._get('paintedWidth'))); }).bind(this)
			var dep$this$width$0 = this
			this.connectOnChanged(dep$this$width$0, 'paintedWidth', update$this$width)
			this._replaceUpdater('width', [[dep$this$width$0, 'paintedWidth', update$this$width]])
			update$this$width();
//assigning height to (this._get('paintedHeight'))
			var update$this$height = (function() { this.height = ((this._get('paintedHeight'))); }).bind(this)
			var dep$this$height$0 = this
			this.connectOnChanged(dep$this$height$0, 'paintedHeight', update$this$height)
			this._replaceUpdater('height', [[dep$this$height$0, 'paintedHeight', update$this$height]])
			update$this$height();
}


//=====[component core.Transform]=====================

	var TransformBaseComponent = _globals.core.Object
	var TransformBasePrototype = TransformBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var TransformComponent = _globals.core.Transform = function(parent, _delegate) {
		TransformBaseComponent.apply(this, arguments)
	//custom constructor:
	{ this._transforms = {} }

	}
	var TransformPrototype = TransformComponent.prototype = Object.create(TransformBasePrototype)

	TransformPrototype.constructor = TransformComponent

	TransformPrototype.componentName = 'core.Transform'
	TransformPrototype._update = function(name,value) {
		switch(name) {
			case 'perspective':	this._transforms['perspective'] = value + 'px'; break;
			case 'translateX':	this._transforms['translateX'] = value + 'px'; break;
			case 'translateY':	this._transforms['translateY'] = value + 'px'; break;
			case 'translateZ':	this._transforms['translateZ'] = value + 'px'; break;
			case 'rotateX':	this._transforms['rotateX'] = value + 'deg'; break
			case 'rotateY':	this._transforms['rotateY'] = value + 'deg'; break
			case 'rotateZ':	this._transforms['rotateZ'] = value + 'deg'; break
			case 'rotate':	this._transforms['rotate'] = value + 'deg'; break
			case 'scaleX':	this._transforms['scaleX'] = value; break
			case 'scaleY':	this._transforms['scaleY'] = value; break
			case 'skewX':	this._transforms['skewX'] = value + 'deg'; break
			case 'skewY':	this._transforms['skewY'] = value + 'deg'; break
		}

		var str = ""
		for (var i in this._transforms) {
			str += i
			str += "(" + this._transforms[i] + ") "
		}
		this.parent.style('transform', str)
		_globals.core.Object.prototype._update.apply(this, arguments)
	}
	core.addProperty(TransformPrototype, 'int', 'perspective')
	core.addProperty(TransformPrototype, 'int', 'translateX')
	core.addProperty(TransformPrototype, 'int', 'translateY')
	core.addProperty(TransformPrototype, 'int', 'translateZ')
	core.addProperty(TransformPrototype, 'real', 'rotateX')
	core.addProperty(TransformPrototype, 'real', 'rotateY')
	core.addProperty(TransformPrototype, 'real', 'rotateZ')
	core.addProperty(TransformPrototype, 'real', 'rotate')
	core.addProperty(TransformPrototype, 'real', 'scaleX')
	core.addProperty(TransformPrototype, 'real', 'scaleY')
	core.addProperty(TransformPrototype, 'real', 'skewX')
	core.addProperty(TransformPrototype, 'real', 'skewY')

//=====[component core.Anchors]=====================

	var AnchorsBaseComponent = _globals.core.Object
	var AnchorsBasePrototype = AnchorsBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var AnchorsComponent = _globals.core.Anchors = function(parent, _delegate) {
		AnchorsBaseComponent.apply(this, arguments)

	}
	var AnchorsPrototype = AnchorsComponent.prototype = Object.create(AnchorsBasePrototype)

	AnchorsPrototype.constructor = AnchorsComponent

	AnchorsPrototype.componentName = 'core.Anchors'
	AnchorsPrototype.marginsUpdated = _globals.core.createSignal('marginsUpdated')
	AnchorsPrototype._updateBottom = function() {
		var anchors = this
		var self = anchors.parent
		var parent = self.parent

		var parent_box = parent.toScreen()
		var bottom = anchors.bottom.toScreen()

		var tm = anchors.topMargin || anchors.margins
		var bm = anchors.bottomMargin || anchors.margins
		if (anchors.top) {
			var top = anchors.top.toScreen()
			self.height = bottom - top - bm - tm
		}
		self.y = bottom - parent_box[1] - bm - self.height - self.viewY
	}
	AnchorsPrototype._updateTop = function() {
		var anchors = this
		var self = anchors.parent
		var parent = self.parent

		var parent_box = parent.toScreen()
		var top = anchors.top.toScreen()

		var tm = anchors.topMargin || anchors.margins
		var bm = anchors.bottomMargin || anchors.margins
		self.y = top + tm - parent_box[1] - self.viewY
		if (anchors.bottom) {
			var bottom = anchors.bottom.toScreen()
			self.height = bottom - top - bm - tm
		}
	}
	AnchorsPrototype._updateRight = function() {
		var anchors = this
		var self = anchors.parent
		var parent = self.parent

		var parent_box = parent.toScreen()
		var right = anchors.right.toScreen()

		var lm = anchors.leftMargin || anchors.margins
		var rm = anchors.rightMargin || anchors.margins
		if (anchors.left) {
			var left = anchors.left.toScreen()
			self.width = right - left - rm - lm
		}
		self.x = right - parent_box[0] - rm - self.width - self.viewX
	}
	AnchorsPrototype._updateVCenter = function() {
		var anchors = this
		var self = anchors.parent
		var parent = self.parent

		var parent_box = parent.toScreen();
		var vcenter = anchors.verticalCenter.toScreen();
		var tm = anchors.topMargin || anchors.margins;
		var bm = anchors.bottomMargin || anchors.margins;
		self.y = vcenter - self.height / 2 - parent_box[1] + tm - bm - self.viewY;
	}
	AnchorsPrototype._updateLeft = function() {
		var anchors = this
		var self = anchors.parent
		var parent = self.parent

		var parent_box = parent.toScreen()
		var left = anchors.left.toScreen()

		var lm = anchors.leftMargin || anchors.margins
		self.x = left + lm - parent_box[0] - self.viewX
		if (anchors.right) {
			var right = anchors.right.toScreen()
			var rm = anchors.rightMargin || anchors.margins
			self.width = right - left - rm - lm
		}
	}
	AnchorsPrototype._updateHCenter = function() {
		var anchors = this
		var self = anchors.parent
		var parent = self.parent

		var parent_box = parent.toScreen();
		var hcenter = anchors.horizontalCenter.toScreen();
		var lm = anchors.leftMargin || anchors.margins;
		var rm = anchors.rightMargin || anchors.margins;
		self.x = hcenter - self.width / 2 - parent_box[0] + lm - rm - self.viewX;
	}
	core.addProperty(AnchorsPrototype, 'AnchorLine', 'bottom')
	core.addProperty(AnchorsPrototype, 'AnchorLine', 'verticalCenter')
	core.addProperty(AnchorsPrototype, 'AnchorLine', 'top')
	core.addProperty(AnchorsPrototype, 'AnchorLine', 'left')
	core.addProperty(AnchorsPrototype, 'AnchorLine', 'horizontalCenter')
	core.addProperty(AnchorsPrototype, 'AnchorLine', 'right')
	core.addProperty(AnchorsPrototype, 'Item', 'fill')
	core.addProperty(AnchorsPrototype, 'Item', 'centerIn')
	core.addProperty(AnchorsPrototype, 'int', 'margins')
	core.addProperty(AnchorsPrototype, 'int', 'bottomMargin')
	core.addProperty(AnchorsPrototype, 'int', 'topMargin')
	core.addProperty(AnchorsPrototype, 'int', 'leftMargin')
	core.addProperty(AnchorsPrototype, 'int', 'rightMargin')
	_globals.core._protoOnChanged(AnchorsPrototype, 'bottom', (function(value) {
		var self = this.parent
		var anchors = this
		self._replaceUpdater('y')
		if (anchors.top)
			self._replaceUpdater('height')
		var update_bottom = anchors._updateBottom.bind(this)
		update_bottom()
		self.onChanged('height', update_bottom)
		self.connectOn(anchors.bottom.parent, 'boxChanged', update_bottom)
		anchors.onChanged('bottomMargin', update_bottom)
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'bottomMargin', (function(value) { this.marginsUpdated(); } ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'leftMargin', (function(value) { this.marginsUpdated(); } ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'left', (function(value) {
		var self = this.parent
		var anchors = this
		self._replaceUpdater('x')
		if (anchors.right)
			self._replaceUpdater('width')
		var update_left = anchors._updateLeft.bind(this)
		update_left()
		self.connectOn(anchors.left.parent, 'boxChanged', update_left)
		anchors.onChanged('leftMargin', update_left)
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'topMargin', (function(value) { this.marginsUpdated(); } ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'rightMargin', (function(value) { this.marginsUpdated(); } ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'centerIn', (function(value) {
		this.horizontalCenter = value.horizontalCenter
		this.verticalCenter = value.verticalCenter
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'verticalCenter', (function(value) {
		var self = this.parent
		var anchors = this
		var update_v_center = anchors._updateVCenter.bind(this)
		self._replaceUpdater('y')
		update_v_center()
		self.onChanged('height', update_v_center)
		anchors.onChanged('topMargin', update_v_center)
		anchors.onChanged('bottomMargin', update_v_center)
		self.connectOn(anchors.verticalCenter.parent, 'boxChanged', update_v_center)
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'top', (function(value) {
		var self = this.parent
		var anchors = this
		self._replaceUpdater('y')
		if (anchors.bottom)
			self._replaceUpdater('height')
		var update_top = anchors._updateTop.bind(this)
		update_top()
		self.connectOn(anchors.top.parent, 'boxChanged', update_top)
		anchors.onChanged('topMargin', update_top)
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'fill', (function(value) {
		var fill = value
		this.left = fill.left
		this.right = fill.right
		this.top = fill.top
		this.bottom = fill.bottom
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'horizontalCenter', (function(value) {
		var self = this.parent
		var anchors = this
		self._replaceUpdater('x')
		var update_h_center = anchors._updateHCenter.bind(this)
		update_h_center()
		self.onChanged('width', update_h_center)
		anchors.onChanged('leftMargin', update_h_center)
		anchors.onChanged('rightMargin', update_h_center)
		self.connectOn(anchors.horizontalCenter.parent, 'boxChanged', update_h_center)
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'right', (function(value) {
		var self = this.parent
		var anchors = this
		self._replaceUpdater('x')
		if (anchors.left)
			anchors._replaceUpdater('width')
		var update_right = anchors._updateRight.bind(anchors)
		update_right()
		self.onChanged('width', update_right)
		self.connectOn(anchors.right.parent, 'boxChanged', update_right)
		anchors.onChanged('rightMargin', update_right)
	} ))
	_globals.core._protoOnChanged(AnchorsPrototype, 'margin', (function(value) { this.marginsUpdated(); } ))

//=====[component core.Image]=====================

	var ImageBaseComponent = _globals.core.Item
	var ImageBasePrototype = ImageBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Item}
 */
	var ImageComponent = _globals.core.Image = function(parent, _delegate) {
		ImageBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._context.backend.initImage(this)
		this.load()
	}

	}
	var ImagePrototype = ImageComponent.prototype = Object.create(ImageBasePrototype)

	ImagePrototype.constructor = ImageComponent

	ImagePrototype.componentName = 'core.Image'
	ImagePrototype._load = function() {
		this._context.backend.loadImage(this)
	}
	ImagePrototype.load = function() {
		this.status = (this.source.length === 0) ? _globals.core.Image.prototype.Null: _globals.core.Image.prototype.Loading
		this._scheduleLoad()
	}
	ImagePrototype._scheduleLoad = function() {
		this._context.delayedAction('image.load', this, this._load)
	}
	ImagePrototype._onError = function() {
		this.status = this.Error;
	}
	core.addProperty(ImagePrototype, 'int', 'paintedWidth')
	core.addProperty(ImagePrototype, 'int', 'paintedHeight')
	core.addProperty(ImagePrototype, 'int', 'sourceWidth')
	core.addProperty(ImagePrototype, 'int', 'sourceHeight')
	core.addProperty(ImagePrototype, 'string', 'source')
/** @const @type {number} */
	ImagePrototype.Null = 0
/** @const @type {number} */
	ImageComponent.Null = 0
/** @const @type {number} */
	ImagePrototype.Ready = 1
/** @const @type {number} */
	ImageComponent.Ready = 1
/** @const @type {number} */
	ImagePrototype.Loading = 2
/** @const @type {number} */
	ImageComponent.Loading = 2
/** @const @type {number} */
	ImagePrototype.Error = 3
/** @const @type {number} */
	ImageComponent.Error = 3
	core.addProperty(ImagePrototype, 'enum', 'status')
/** @const @type {number} */
	ImagePrototype.Stretch = 0
/** @const @type {number} */
	ImageComponent.Stretch = 0
/** @const @type {number} */
	ImagePrototype.PreserveAspectFit = 1
/** @const @type {number} */
	ImageComponent.PreserveAspectFit = 1
/** @const @type {number} */
	ImagePrototype.PreserveAspectCrop = 2
/** @const @type {number} */
	ImageComponent.PreserveAspectCrop = 2
/** @const @type {number} */
	ImagePrototype.Tile = 3
/** @const @type {number} */
	ImageComponent.Tile = 3
/** @const @type {number} */
	ImagePrototype.TileVertically = 4
/** @const @type {number} */
	ImageComponent.TileVertically = 4
/** @const @type {number} */
	ImagePrototype.TileHorizontally = 5
/** @const @type {number} */
	ImageComponent.TileHorizontally = 5
/** @const @type {number} */
	ImagePrototype.Pad = 6
/** @const @type {number} */
	ImageComponent.Pad = 6
	core.addProperty(ImagePrototype, 'enum', 'fillMode')
	_globals.core._protoOnChanged(ImagePrototype, 'source', (function(value) { this.load() } ))
	_globals.core._protoOnChanged(ImagePrototype, 'width', (function(value) { this.load() } ))
	_globals.core._protoOnChanged(ImagePrototype, 'fillMode', (function(value) { this.load() } ))
	_globals.core._protoOnChanged(ImagePrototype, 'height', (function(value) { this.load() } ))

//=====[component core.ListModel]=====================

	var ListModelBaseComponent = _globals.core.Object
	var ListModelBasePrototype = ListModelBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var ListModelComponent = _globals.core.ListModel = function(parent, _delegate) {
		ListModelBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._rows = []
	}

	}
	var ListModelPrototype = ListModelComponent.prototype = Object.create(ListModelBasePrototype)

	ListModelPrototype.constructor = ListModelComponent

	ListModelPrototype.componentName = 'core.ListModel'
	ListModelPrototype.reset = _globals.core.createSignal('reset')
	ListModelPrototype.rowsChanged = _globals.core.createSignal('rowsChanged')
	ListModelPrototype.rowsRemoved = _globals.core.createSignal('rowsRemoved')
	ListModelPrototype.rowsInserted = _globals.core.createSignal('rowsInserted')
	ListModelPrototype.insert = function(idx,row) {
		if (idx < 0 || idx > this._rows.length)
			throw new Error('index ' + idx + ' out of bounds (' + this._rows.length + ')')
		this._rows.splice(idx, 0, row)
		this.count = this._rows.length
		this.rowsInserted(idx, idx + 1)
	}
	ListModelPrototype.addChild = function(child) {
		this.append(child)
	}
	ListModelPrototype.remove = function(idx,n) {
		if (idx < 0 || idx >= this._rows.length)
			throw new Error('index ' + idx + ' out of bounds')
		if (n === undefined)
			n = 1
		this._rows.splice(idx, n)
		this.count = this._rows.length
		this.rowsRemoved(idx, idx + n)
	}
	ListModelPrototype.setProperty = function(idx,name,value) {
		if (idx < 0 || idx >= this._rows.length)
			throw new Error('index ' + idx + ' out of bounds (' + this._rows.length + ')')
		var row = this._rows[idx]
		if (!(row instanceof Object))
			throw new Error('row is non-object, invalid index? (' + idx + ')')

		if (row[name] !== value) {
			row[name] = value
			this.rowsChanged(idx, idx + 1)
		}
	}
	ListModelPrototype.get = function(idx) {
		if (idx < 0 || idx >= this._rows.length)
			throw new Error('index ' + idx + ' out of bounds (' + this._rows.length + ')')
		var row = this._rows[idx]
		if (!(row instanceof Object))
			throw new Error('row is non-object')
		row.index = idx
		return row
	}
	ListModelPrototype.clear = function() { this.assign([]) }
	ListModelPrototype.append = function(row) {
		var l = this._rows.length
		if (Array.isArray(row)) {
			Array.prototype.push.apply(this._rows, row)
			this.count = this._rows.length
			this.rowsInserted(l, l + row.length)
		} else {
			this._rows.push(row)
			this.count = this._rows.length
			this.rowsInserted(l, l + 1)
		}
	}
	ListModelPrototype.set = function(idx,row) {
		if (idx < 0 || idx >= this._rows.length)
			throw new Error('index ' + idx + ' out of bounds (' + this._rows.length + ')')
		if (!(row instanceof Object))
			throw new Error('row is non-object')
		this._rows[idx] = row
		this.rowsChanged(idx, idx + 1)
	}
	ListModelPrototype.assign = function(rows) {
		this._rows = rows
		this.count = this._rows.length
		this.reset()
	}
	core.addProperty(ListModelPrototype, 'int', 'count')

//=====[component core.AnchorLine]=====================

	var AnchorLineBaseComponent = _globals.core.Object
	var AnchorLineBasePrototype = AnchorLineBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var AnchorLineComponent = _globals.core.AnchorLine = function(parent, _delegate) {
		AnchorLineBaseComponent.apply(this, arguments)

	}
	var AnchorLinePrototype = AnchorLineComponent.prototype = Object.create(AnchorLineBasePrototype)

	AnchorLinePrototype.constructor = AnchorLineComponent

	AnchorLinePrototype.componentName = 'core.AnchorLine'
	AnchorLinePrototype.toScreen = function() {
		return this.parent.toScreen()[this.boxIndex]
	}
	core.addProperty(AnchorLinePrototype, 'int', 'boxIndex')

//=====[component core.Gradient]=====================

	var GradientBaseComponent = _globals.core.Object
	var GradientBasePrototype = GradientBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var GradientComponent = _globals.core.Gradient = function(parent, _delegate) {
		GradientBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this.stops = []
	}

	}
	var GradientPrototype = GradientComponent.prototype = Object.create(GradientBasePrototype)

	GradientPrototype.constructor = GradientComponent

	GradientPrototype.componentName = 'core.Gradient'
	GradientPrototype.addChild = function(child) {
		_globals.core.Object.prototype.addChild.apply(this, arguments)
		if (child instanceof _globals.core.GradientStop) {
			this.stops.push(child)
			this.stops.sort(function(a, b) { return a.position > b.position; })
			this._updateStyle()
		}
	}
	GradientPrototype._updateStyle = function() {
		var decl = this._getDeclaration()
		if (decl)
			this.parent.style({ 'background-color': '', 'background': 'linear-gradient(' + decl + ')' })
	}
	GradientPrototype._getDeclaration = function() {
		var stops = this.stops
		var n = stops.length
		if (n < 2)
			return

		var decl = []
		var orientation = this.orientation == this.Vertical? 'bottom': 'left'

		switch(this.orientation) {
				case this.Vertical:	orientation = 'to bottom'; break
				case this.Horizontal:	orientation = 'to left'; break
				case this.BottomRight:	orientation = 'to bottom right'; break
				case this.TopRight:	orientation = 'to top right'; break
				case this.Custom:	orientation = this.angle + 'deg'; break
		}

		decl.push(orientation)

		for(var i = 0; i < n; ++i) {
			var stop = stops[i]
			decl.push(stop._getDeclaration())
		}
		return decl.join()
	}
	core.addProperty(GradientPrototype, 'real', 'angle')
/** @const @type {number} */
	GradientPrototype.Vertical = 0
/** @const @type {number} */
	GradientComponent.Vertical = 0
/** @const @type {number} */
	GradientPrototype.Horizontal = 1
/** @const @type {number} */
	GradientComponent.Horizontal = 1
/** @const @type {number} */
	GradientPrototype.BottomRight = 2
/** @const @type {number} */
	GradientComponent.BottomRight = 2
/** @const @type {number} */
	GradientPrototype.TopRight = 3
/** @const @type {number} */
	GradientComponent.TopRight = 3
/** @const @type {number} */
	GradientPrototype.Custom = 4
/** @const @type {number} */
	GradientComponent.Custom = 4
	core.addProperty(GradientPrototype, 'enum', 'orientation')

	GradientPrototype.__create = function(__closure) {
		GradientBasePrototype.__create.call(this, __closure.__base = { })

	}
	GradientPrototype.__setup = function(__closure) {
	GradientBasePrototype.__setup.call(this, __closure.__base); delete __closure.__base
this._context._onCompleted((function() {
		this._updateStyle()
	} ).bind(this))
}


//=====[component core.RAIIEventEmitter]=====================

	var RAIIEventEmitterBaseComponent = _globals.core.EventEmitter
	var RAIIEventEmitterBasePrototype = RAIIEventEmitterBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.EventEmitter}
 */
	var RAIIEventEmitterComponent = _globals.core.RAIIEventEmitter = function(parent, _delegate) {
		RAIIEventEmitterBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		this._onFirstListener = {}
		this._onLastListener = {}
	}

	}
	var RAIIEventEmitterPrototype = RAIIEventEmitterComponent.prototype = Object.create(RAIIEventEmitterBasePrototype)

	RAIIEventEmitterPrototype.constructor = RAIIEventEmitterComponent

	RAIIEventEmitterPrototype.componentName = 'core.RAIIEventEmitter'
	RAIIEventEmitterPrototype.discard = function() {
		_globals.core.EventEmitter.prototype.discard.apply(this)
	}
	RAIIEventEmitterPrototype.on = function(name,callback) {
		if (!(name in this._eventHandlers)) {
			if (name in this._onFirstListener) {
				//log('first listener to', name)
				this._onFirstListener[name](name)
			} else if ('' in this._onFirstListener) {
				//log('first listener to', name)
				this._onFirstListener[''](name)
			}
			if (this._eventHandlers[name])
				throw new Error('listener callback added event handler')
		}
		_globals.core.EventEmitter.prototype.on.call(this, name, callback)
	}
	RAIIEventEmitterPrototype.onListener = function(name,first,last) {
		this._onFirstListener[name] = first
		this._onLastListener[name] = last
	}
	RAIIEventEmitterPrototype.removeAllListeners = function(name) {
		_globals.core.EventEmitter.prototype.removeAllListeners.call(this, name)
		if (name in this._onLastListener)
			this._onLastListener[name](name)
		else if ('' in this._onLastListener) {
			//log('first listener to', name)
			this._onLastListener[''](name)
		}
	}

//=====[component html5.Stylesheet]=====================

	var StylesheetBaseComponent = _globals.core.Object
	var StylesheetBasePrototype = StylesheetBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var StylesheetComponent = _globals.html5.Stylesheet = function(parent, _delegate) {
		StylesheetBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		var context = this._context
		var options = context.options

		var style = this.style = context.createElement('style')
		style.dom.type = 'text/css'

		this.prefix = options.prefix
		var divId = options.id

		var div = document.getElementById(divId)
		var topLevel = div === null

		var userSelect = window.Modernizr.prefixedCSS('user-select') + ": none; "
		style.setHtml(
			"div#" + divId + " { position: absolute; visibility: inherit; left: 0px; top: 0px; }" +
			"div." + this._context.getClass('core-text') + " { width: auto; height: auto; visibility: inherit; }" +
			(topLevel? "body { padding: 0; margin: 0; border: 0px; overflow: hidden; }": "") + //fixme: do we need style here in non-top-level mode?
			this.mangleRule('video', "{ position: absolute; visibility: inherit; }") +
			this.mangleRule('img', "{ position: absolute; visibility: inherit; -webkit-touch-callout: none; " + userSelect + " }")
		)
		_globals.html5.html.getElement('head').append(style)

		this._addRule = _globals.html5.html.createAddRule(style.dom).bind(this)
		this._lastId = 0
	}

	}
	var StylesheetPrototype = StylesheetComponent.prototype = Object.create(StylesheetBasePrototype)

	StylesheetPrototype.constructor = StylesheetComponent

	StylesheetPrototype.componentName = 'html5.Stylesheet'
	StylesheetPrototype.allocateClass = function(prefix) {
		var globalPrefix = this.prefix
		return (globalPrefix? globalPrefix: '') + prefix + '-' + this._lastId++
	}
	StylesheetPrototype.addRule = function(selector,rule) {
		var mangledSelector = this.mangleSelector(selector)
		this._addRule(mangledSelector, rule)
	}
	StylesheetPrototype.mangleRule = function(selector,rule) {
		return this.mangleSelector(selector) + ' ' + rule + ' '
	}
	StylesheetPrototype.mangleSelector = function(selector) {
		var prefix = this.prefix
		if (prefix)
			return selector + '.' + prefix + 'core-item'
		else
			return selector
	}

//=====[component html5.Location]=====================

	var LocationBaseComponent = _globals.core.Object
	var LocationBasePrototype = LocationBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var LocationComponent = _globals.html5.Location = function(parent, _delegate) {
		LocationBaseComponent.apply(this, arguments)
	//custom constructor:
	{
		var self = this
		var location = window.location
		this.updateActualValues()
		window.onhashchange = function() { self.hash = location.hash }
		window.onpopstate = function() { self.updateActualValues() }
	}

	}
	var LocationPrototype = LocationComponent.prototype = Object.create(LocationBasePrototype)

	LocationPrototype.constructor = LocationComponent

	LocationPrototype.componentName = 'html5.Location'
	LocationPrototype.updateActualValues = function() {
		this.hash = window.location.hash
		this.href = window.location.href
		this.port = window.location.port
		this.host = window.location.host
		this.origin = window.location.origin
		this.hostname = window.location.hostname
		this.pathname = window.location.pathname
		this.protocol = window.location.protocol
		this.search = window.location.search
		this.state = window.history.state
	}
	LocationPrototype.changeHref = function(href) {
		window.location.href = href
		this.updateActualValues()
	}
	LocationPrototype.pushState = function(state,title,url) {
		if (window.location.hostname) {
			window.history.pushState(state, title, url)
			this.updateActualValues()
		} else {
			document.title = title
			this.state = state
		}
	}
	core.addProperty(LocationPrototype, 'string', 'hash')
	core.addProperty(LocationPrototype, 'string', 'host')
	core.addProperty(LocationPrototype, 'string', 'href')
	core.addProperty(LocationPrototype, 'string', 'port')
	core.addProperty(LocationPrototype, 'string', 'origin')
	core.addProperty(LocationPrototype, 'string', 'hostname')
	core.addProperty(LocationPrototype, 'string', 'pathname')
	core.addProperty(LocationPrototype, 'string', 'protocol')
	core.addProperty(LocationPrototype, 'string', 'search')
	core.addProperty(LocationPrototype, 'Object', 'state')

//=====[component html5.Orientation]=====================

	var OrientationBaseComponent = _globals.core.Object
	var OrientationBasePrototype = OrientationBaseComponent.prototype

/**
 * @constructor
 * @extends {_globals.core.Object}
 */
	var OrientationComponent = _globals.html5.Orientation = function(parent, _delegate) {
		OrientationBaseComponent.apply(this, arguments)

	}
	var OrientationPrototype = OrientationComponent.prototype = Object.create(OrientationBasePrototype)

	OrientationPrototype.constructor = OrientationComponent

	OrientationPrototype.componentName = 'html5.Orientation'
	OrientationPrototype.onChanged = function(name,callback) {
		if (!this._orientationEnabled) {
			var self = this
			window.ondeviceorientation = function(e) {
				self.absolute = e.absolute
				self.alpha = e.alpha
				self.beta = e.beta
				self.gamma = e.gamma
			}
			this._orientationEnabled = true;
		}

		_globals.core.Object.prototype.onChanged.apply(this, arguments);
	}
	core.addProperty(OrientationPrototype, 'real', 'alpha')
	core.addProperty(OrientationPrototype, 'real', 'beta')
	core.addProperty(OrientationPrototype, 'real', 'gamma')
	core.addProperty(OrientationPrototype, 'bool', 'absolute')
_globals.core.model = (function() {/** @const */
var exports = {};
exports._get = function(name) { return exports[name] }
//=====[import core.model]=====================

var ModelUpdateNothing = 0
var ModelUpdateInsert = 1
var ModelUpdateUpdate = 2

var ModelUpdateRange = function(type, length) {
	this.type = type
	this.length = length
}

exports.ModelUpdate = function() {
	this.count = 0
	this._reset()
}
exports.ModelUpdate.prototype.constructor = exports.ModelUpdate

exports.ModelUpdate.prototype._reset = function() {
	this._ranges = [new ModelUpdateRange(ModelUpdateNothing, this.count)]
	this._updateIndex = this.count
}

exports.ModelUpdate.prototype._setUpdateIndex = function(begin) {
	if (begin < this._updateIndex)
		this._updateIndex = begin
}

exports.ModelUpdate.prototype._find = function(index) {
	var ranges = this._ranges
	var i
	for(i = 0; i < ranges.length; ++i) {
		var range = ranges[i]
		if (index < range.length)
			return { index: i, offset: index }
		if (range.length > 0)
			index -= range.length
	}
	if (index != 0)
		throw new Error('invalid index ' + index)

	return { index: i - 1, offset: range.length }
}

exports.ModelUpdate.prototype.reset = function(model) {
	this.update(model, 0, Math.min(model.count, this.count))
	if (this.count < model.count) {
		this.insert(model, this.count, model.count)
	} else {
		this.remove(model, model.count, this.count)
	}
}

exports.ModelUpdate.prototype._merge = function() {
	var ranges = this._ranges
	for(var index = 1; index < ranges.length; ) {
		var range = ranges[index - 1]
		var nextRange = ranges[index]
		if (range.type === nextRange.type) {
			if (range.type === ModelUpdateInsert && range.length < 0 && nextRange.length > 0) {
				//removed + inserted rows reappers as updated
				var updated = Math.min(-range.length, nextRange.length)
				range.type = ModelUpdateUpdate
				nextRange.length += range.length
				range.length = updated
				if (index > 1)
					--index
			} else {
				range.length += nextRange.length
				ranges.splice(index, 1)
			}
		} else if (range.type == ModelUpdateInsert && range.length === 0) {
			ranges.splice(index, 1)
		} else
			++index
	}
}

exports.ModelUpdate.prototype._split = function(index, offset, type, length) {
	var ranges = this._ranges
	if (offset == 0) {
		ranges.splice(index, 0, new ModelUpdateRange(type, length))
		return index + 1
	} else {
		var range = ranges[index]
		var right = range.length - offset
		range.length = offset
		if (right != 0) {
			ranges.splice(index + 1, 0,
				new ModelUpdateRange(type, length),
				new ModelUpdateRange(range.type, right))
			return index + 2
		} else {
			ranges.splice(index + 1, 0,
				new ModelUpdateRange(type, length))
			return index + 2
		}
	}
}

exports.ModelUpdate.prototype.insert = function(model, begin, end) {
	if (begin >= end)
		return

	this._setUpdateIndex(begin)
	var ranges = this._ranges
	var d = end - begin
	this.count += d
	if (this.count != model.count)
		throw new Error('unbalanced insert ' + this.count + ' + [' + begin + '-' + end + '], model reported ' + model.count)

	var res = this._find(begin)
	var range = ranges[res.index]
	if (range.length == 0) { //first insert
		range.type = ModelUpdateInsert
		range.length += d
	} else {
		if (res.offset >= 0)
			this._split(res.index, res.offset, ModelUpdateInsert, d)
		else
			this._split(res.index + 1, 0, ModelUpdateInsert, d)
	}
	this._merge()
}

exports.ModelUpdate.prototype.remove = function(model, begin, end) {
	if (begin >= end)
		return

	this._setUpdateIndex(begin)
	var ranges = this._ranges
	var d = end - begin
	this.count -= d
	if (this.count != model.count)
		throw new Error('unbalanced remove ' + this.count + ' + [' + begin + '-' + end + '], model reported ' + model.count)

	var res = this._find(begin)
	var range = ranges[res.index]

	if (range.type == ModelUpdateInsert) {
		range.length -= d
	} else {
		var index = this._split(res.index, res.offset, ModelUpdateInsert, -d)
		while(d > 0) {
			var range = ranges[index]
			if (range.length <= d) {
				ranges.splice(index, 1)
				d -= range.length
			} else {
				range.length -= d
				d = 0
			}
		}
	}
	this._merge()
}

exports.ModelUpdate.prototype.update = function(model, begin, end) {
	if (begin >= end)
		return

	var ranges = this._ranges
	var n = end - begin
	var res = this._find(begin)
	var index = res.index

	var range = ranges[index]
	if (res.offset > 0) {
		ranges.splice(index + 1, 0, new ModelUpdateRange(range.type, range.length - res.offset))
		range.length = res.offset
		++index
		if (range.length == 0)
			throw new Error('invalid offset')
	}

	while(n > 0) {
		var range = ranges[index]
		var length = range.length
		switch(range.type) {
			case ModelUpdateNothing:
				if (length > n) {
					//range larger than needed
					range.length -= n
					ranges.splice(index, 0, new ModelUpdateRange(ModelUpdateUpdate, n))
					n -= length
				} else { //length <= n
					range.type = ModelUpdateUpdate
					n -= length
				}
				break
			case ModelUpdateInsert:
				if (length > 0)
					n -= length
				++index
				break
			case ModelUpdateUpdate:
				n -= length
				++index
				break
		}
	}
	this._merge()
}

exports.ModelUpdate.prototype.apply = function(view, skipCheck) {
	var index = 0
	this._ranges.forEach(
		function(range) {
			var n = range.length
			switch(range.type) {
				case ModelUpdateInsert:
					if (n > 0) {
						view._insertItems(index, index + n)
						index += n
					} else if (n < 0) {
						view._removeItems(index, index - n)
					}
					break
				case ModelUpdateUpdate:
					view._updateItems(index, index + n)
					index += n
					break
				default:
					index += range.length
			}
		}
	)
	if (!skipCheck && view._items.length != this.count)
		throw new Error('unbalanced items update, view: ' + view._items.length + ', update:' + this.count)

	for(var i = this._updateIndex; i < this.count; ++i)
		view._updateDelegateIndex(i)
	this._reset()
}

return exports;
} )()
_globals.html5.dist.modernizr_custom = (function() {/** @const */
var exports = {};
exports._get = function(name) { return exports[name] }
//=====[import html5.dist.modernizr-custom]=====================

/*! modernizr 3.3.1 (Custom Build) | MIT *
 * http://modernizr.com/download/?-cssfilters-cssgradients-csstransforms-csstransforms3d-csstransitions-fullscreen-webworkers-domprefixes-prefixed-prefixedcss-prefixedcssvalue-setclasses-testallprops-testprop !*/
!function(e,n,t){function r(e,n){return typeof e===n}function s(){var e,n,t,s,i,o,a;for(var f in x)if(x.hasOwnProperty(f)){if(e=[],n=x[f],n.name&&(e.push(n.name.toLowerCase()),n.options&&n.options.aliases&&n.options.aliases.length))for(t=0;t<n.options.aliases.length;t++)e.push(n.options.aliases[t].toLowerCase());for(s=r(n.fn,"function")?n.fn():n.fn,i=0;i<e.length;i++)o=e[i],a=o.split("."),1===a.length?Modernizr[a[0]]=s:(!Modernizr[a[0]]||Modernizr[a[0]]instanceof Boolean||(Modernizr[a[0]]=new Boolean(Modernizr[a[0]])),Modernizr[a[0]][a[1]]=s),y.push((s?"":"no-")+a.join("-"))}}function i(e){var n=w.className,t=Modernizr._config.classPrefix||"";if(S&&(n=n.baseVal),Modernizr._config.enableJSClass){var r=new RegExp("(^|\\s)"+t+"no-js(\\s|$)");n=n.replace(r,"$1"+t+"js$2")}Modernizr._config.enableClasses&&(n+=" "+t+e.join(" "+t),S?w.className.baseVal=n:w.className=n)}function o(e){return e.replace(/([a-z])-([a-z])/g,function(e,n,t){return n+t.toUpperCase()}).replace(/^-/,"")}function a(e){return e.replace(/([A-Z])/g,function(e,n){return"-"+n.toLowerCase()}).replace(/^ms-/,"-ms-")}function f(){return"function"!=typeof n.createElement?n.createElement(arguments[0]):S?n.createElementNS.call(n,"http://www.w3.org/2000/svg",arguments[0]):n.createElement.apply(n,arguments)}function l(e,n){return!!~(""+e).indexOf(n)}function u(e,n){return function(){return e.apply(n,arguments)}}function d(e,n,t){var s;for(var i in e)if(e[i]in n)return t===!1?e[i]:(s=n[e[i]],r(s,"function")?u(s,t||n):s);return!1}function p(){var e=n.body;return e||(e=f(S?"svg":"body"),e.fake=!0),e}function c(e,t,r,s){var i,o,a,l,u="modernizr",d=f("div"),c=p();if(parseInt(r,10))for(;r--;)a=f("div"),a.id=s?s[r]:u+(r+1),d.appendChild(a);return i=f("style"),i.type="text/css",i.id="s"+u,(c.fake?c:d).appendChild(i),c.appendChild(d),i.styleSheet?i.styleSheet.cssText=e:i.appendChild(n.createTextNode(e)),d.id=u,c.fake&&(c.style.background="",c.style.overflow="hidden",l=w.style.overflow,w.style.overflow="hidden",w.appendChild(c)),o=t(d,e),c.fake?(c.parentNode.removeChild(c),w.style.overflow=l,w.offsetHeight):d.parentNode.removeChild(d),!!o}function m(n,r){var s=n.length;if("CSS"in e&&"supports"in e.CSS){for(;s--;)if(e.CSS.supports(a(n[s]),r))return!0;return!1}if("CSSSupportsRule"in e){for(var i=[];s--;)i.push("("+a(n[s])+":"+r+")");return i=i.join(" or "),c("@supports ("+i+") { #modernizr { position: absolute; } }",function(e){return"absolute"==getComputedStyle(e,null).position})}return t}function v(e,n,s,i){function a(){d&&(delete A.style,delete A.modElem)}if(i=r(i,"undefined")?!1:i,!r(s,"undefined")){var u=m(e,s);if(!r(u,"undefined"))return u}for(var d,p,c,v,g,h=["modernizr","tspan"];!A.style;)d=!0,A.modElem=f(h.shift()),A.style=A.modElem.style;for(c=e.length,p=0;c>p;p++)if(v=e[p],g=A.style[v],l(v,"-")&&(v=o(v)),A.style[v]!==t){if(i||r(s,"undefined"))return a(),"pfx"==n?v:!0;try{A.style[v]=s}catch(y){}if(A.style[v]!=g)return a(),"pfx"==n?v:!0}return a(),!1}function g(e,n,t,s,i){var o=e.charAt(0).toUpperCase()+e.slice(1),a=(e+" "+E.join(o+" ")+o).split(" ");return r(n,"string")||r(n,"undefined")?v(a,n,s,i):(a=(e+" "+b.join(o+" ")+o).split(" "),d(a,n,t))}function h(e,n,r){return g(e,t,t,n,r)}var y=[],x=[],C={_version:"3.3.1",_config:{classPrefix:"",enableClasses:!0,enableJSClass:!0,usePrefixes:!0},_q:[],on:function(e,n){var t=this;setTimeout(function(){n(t[e])},0)},addTest:function(e,n,t){x.push({name:e,fn:n,options:t})},addAsyncTest:function(e){x.push({name:null,fn:e})}},Modernizr=function(){};Modernizr.prototype=C,Modernizr=new Modernizr,Modernizr.addTest("webworkers","Worker"in e);var w=n.documentElement,S="svg"===w.nodeName.toLowerCase(),_="Moz O ms Webkit",b=C._config.usePrefixes?_.toLowerCase().split(" "):[];C._domPrefixes=b;var T=function(e,n){var t=!1,r=f("div"),s=r.style;if(e in s){var i=b.length;for(s[e]=n,t=s[e];i--&&!t;)s[e]="-"+b[i]+"-"+n,t=s[e]}return""===t&&(t=!1),t};C.prefixedCSSValue=T;var P=C._config.usePrefixes?" -webkit- -moz- -o- -ms- ".split(" "):["",""];C._prefixes=P,Modernizr.addTest("cssgradients",function(){for(var e,n="background-image:",t="gradient(linear,left top,right bottom,from(#9f9),to(white));",r="",s=0,i=P.length-1;i>s;s++)e=0===s?"to ":"",r+=n+P[s]+"linear-gradient("+e+"left top, #9f9, white);";Modernizr._config.usePrefixes&&(r+=n+"-webkit-"+t);var o=f("a"),a=o.style;return a.cssText=r,(""+a.backgroundImage).indexOf("gradient")>-1});var k="CSS"in e&&"supports"in e.CSS,z="supportsCSS"in e;Modernizr.addTest("supports",k||z);var E=C._config.usePrefixes?_.split(" "):[];C._cssomPrefixes=E;var N=function(n){var r,s=P.length,i=e.CSSRule;if("undefined"==typeof i)return t;if(!n)return!1;if(n=n.replace(/^@/,""),r=n.replace(/-/g,"_").toUpperCase()+"_RULE",r in i)return"@"+n;for(var o=0;s>o;o++){var a=P[o],f=a.toUpperCase()+"_"+r;if(f in i)return"@-"+a.toLowerCase()+"-"+n}return!1};C.atRule=N;var j={elem:f("modernizr")};Modernizr._q.push(function(){delete j.elem});var A={style:j.elem.style};Modernizr._q.unshift(function(){delete A.style});var O=C.testStyles=c;C.testProp=function(e,n,r){return v([e],t,n,r)};C.testAllProps=g;var L=C.prefixed=function(e,n,t){return 0===e.indexOf("@")?N(e):(-1!=e.indexOf("-")&&(e=o(e)),n?g(e,n,t):g(e,"pfx"))};C.prefixedCSS=function(e){var n=L(e);return n&&a(n)};Modernizr.addTest("fullscreen",!(!L("exitFullscreen",n,!1)&&!L("cancelFullScreen",n,!1))),C.testAllProps=h,Modernizr.addTest("csstransforms",function(){return-1===navigator.userAgent.indexOf("Android 2.")&&h("transform","scale(1)",!0)}),Modernizr.addTest("csstransforms3d",function(){var e=!!h("perspective","1px",!0),n=Modernizr._config.usePrefixes;if(e&&(!n||"webkitPerspective"in w.style)){var t,r="#modernizr{width:0;height:0}";Modernizr.supports?t="@supports (perspective: 1px)":(t="@media (transform-3d)",n&&(t+=",(-webkit-transform-3d)")),t+="{#modernizr{width:7px;height:18px;margin:0;padding:0;border:0}}",O(r+t,function(n){e=7===n.offsetWidth&&18===n.offsetHeight})}return e}),Modernizr.addTest("csstransitions",h("transition","all",!0)),Modernizr.addTest("cssfilters",function(){if(Modernizr.supports)return h("filter","blur(2px)");var e=f("a");return e.style.cssText=P.join("filter:blur(2px); "),!!e.style.length&&(n.documentMode===t||n.documentMode>9)}),s(),i(y),delete C.addTest,delete C.addAsyncTest;for(var R=0;R<Modernizr._q.length;R++)Modernizr._q[R]();e.Modernizr=Modernizr}(window,document);
return exports;
} )()
_globals.html5.html = (function() {/** @const */
var exports = {};
exports._get = function(name) { return exports[name] }
//=====[import html5.html]=====================

/*** @using { core.RAIIEventEmitter } **/

exports.createAddRule = function(style) {
	if(! (style.sheet || {}).insertRule) {
		var sheet = (style.styleSheet || style.sheet)
		return function(name, rules) { sheet.addRule(name, rules) }
	}
	else {
		var sheet = style.sheet
		return function(name, rules) { sheet.insertRule(name + '{' + rules + '}', sheet.cssRules.length) }
	}
}

var StyleCache = function (prefix) {
	var style = document.createElement('style')
	style.type = 'text/css'
	document.head.appendChild(style)

	this.prefix = prefix + 'C-'
	this.style = style
	this.total = 0
	this.stats = {}
	this.classes = {}
	this.classes_total = 0
	this._addRule = exports.createAddRule(style)
}
var StyleCachePrototype = StyleCache.prototype

StyleCachePrototype.constructor = StyleCache

StyleCachePrototype.add = function(rule) {
	this.stats[rule] = (this.stats[rule] || 0) + 1
	++this.total
}

StyleCachePrototype.register = function(rules) {
	var rule = rules.join(';')
	var classes = this.classes
	var cls = classes[rule]
	if (cls !== undefined)
		return cls

	var cls = classes[rule] = this.prefix + this.classes_total++
	this._addRule('.' + cls, rule)
	return cls
}

StyleCachePrototype.classify = function(rules) {
	var total = this.total
	if (total < 10) //fixme: initial population threshold
		return ''

	rules.sort() //mind vendor prefixes!
	var classified = []
	var hot = []
	var stats = this.stats
	rules.forEach(function(rule, idx) {
		var hits = stats[rule]
		var usage = hits / total
		if (usage > 0.05) { //fixme: usage threshold
			classified.push(rule)
			hot.push(idx)
		}
	})
	if (hot.length < 2)
		return ''
	hot.forEach(function(offset, idx) {
		rules.splice(offset - idx, 1)
	})
	return this.register(classified)
}

var _modernizrCache = {}
if (navigator.userAgent.toLowerCase().indexOf('webkit') >= 0)
	_modernizrCache['appearance'] = '-webkit-appearance'

var getPrefixedName = function(name) {
	var prefixedName = _modernizrCache[name]
	if (prefixedName === undefined)
		_modernizrCache[name] = prefixedName = window.Modernizr.prefixedCSS(name)
	return prefixedName
}

exports.getPrefixedName = getPrefixedName

var registerGenericListener = function(target) {
	var prefix = '_domEventHandler_'
	target.onListener('',
		function(name) {
			var context = target._context
			//log('registering generic event', name)
			var pname = prefix + name
			var callback = target[pname] = function() {
				try { target.emitWithArgs(name, arguments) }
				catch(ex) {
					context._processActions()
					throw ex
				}
				context._processActions()
			}
			target.dom.addEventListener(name, callback)
		},
		function(name) {
			//log('removing generic event', name)
			var pname = prefix + name
			target.dom.removeEventListener(name, target[pname])
		}
	)
}

var _loadedStylesheets = {}

exports.loadExternalStylesheet = function(url) {
	if (!_loadedStylesheets[url]) {
		var link = document.createElement('link')
		link.setAttribute('rel', "stylesheet")
		link.setAttribute('href', url)
		document.head.appendChild(link)
		_loadedStylesheets[url] = true
	}
}

exports.autoClassify = false

/**
 * @constructor
 */

exports.Element = function(context, tag) {
	if (typeof tag === 'string')
		this.dom = document.createElement(tag)
	else
		this.dom = tag

	if (exports.autoClassify) {
		if (!context._styleCache)
			context._styleCache = new StyleCache(context._prefix)
	} else
		context._styleCache = null

	_globals.core.RAIIEventEmitter.apply(this)
	this._context = context
	this._fragment = []
	this._styles = {}
	this._class = ''
	this._widthAdjust = 0

	registerGenericListener(this)
}

var ElementPrototype = exports.Element.prototype = Object.create(_globals.core.RAIIEventEmitter.prototype)
ElementPrototype.constructor = exports.Element

ElementPrototype.addClass = function(cls) {
	this.dom.classList.add(cls)
}

ElementPrototype.setHtml = function(html) {
	this._widthAdjust = 0 //reset any text related rounding corrections
	var dom = this.dom
	this._fragment.forEach(function(node) { dom.removeChild(node) })
	this._fragment = []

	if (html === '')
		return

	var fragment = document.createDocumentFragment()
	var temp = document.createElement('div')

	temp.innerHTML = html
	while (temp.firstChild) {
		this._fragment.push(temp.firstChild)
		fragment.appendChild(temp.firstChild)
	}
	dom.appendChild(fragment)
	return dom.children
}

ElementPrototype.width = function() {
	return this.dom.clientWidth - this._widthAdjust
}

ElementPrototype.height = function() {
	return this.dom.clientHeight
}

ElementPrototype.fullWidth = function() {
	return this.dom.scrollWidth - this._widthAdjust
}

ElementPrototype.fullHeight = function() {
	return this.dom.scrollHeight
}

ElementPrototype.style = function(name, style) {
	if (style !== undefined) {
		if (style !== '') //fixme: replace it with explicit 'undefined' syntax
			this._styles[name] = style
		else
			delete this._styles[name]
		this.updateStyle()
	} else if (name instanceof Object) { //style({ }) assignment
		for(var k in name) {
			var value = name[k]
			if (value !== '') //fixme: replace it with explicit 'undefined' syntax
				this._styles[k] = value
			else
				delete this._styles[k]
		}
		this.updateStyle()
	}
	else
		return this._styles[name]
}

ElementPrototype.setAttribute = function(name, value) {
	this.dom.setAttribute(name, value)
}

ElementPrototype.updateStyle = function() {
	var element = this.dom
	if (!element)
		return

	/** @const */
	var cssUnits = {
		'left': 'px',
		'top': 'px',
		'width': 'px',
		'height': 'px',

		'border-radius': 'px',
		'border-width': 'px',

		'margin-left': 'px',
		'margin-top': 'px',
		'margin-right': 'px',
		'margin-bottom': 'px',

		'padding-left': 'px',
		'padding-top': 'px',
		'padding-right': 'px',
		'padding-bottom': 'px',
		'padding': 'px'
	}

	var cache = this._context._styleCache
	var rules = []
	for(var name in this._styles) {
		var value = this._styles[name]

		var prefixedName = getPrefixedName(name)
		var ruleName = prefixedName !== false? prefixedName: name
		if (Array.isArray(value))
			value = value.join(',')

		var unit = ''
		if (typeof value === 'number') {
			if (name in cssUnits)
				unit = cssUnits[name]
			if (name === 'width')
				value += this._widthAdjust
		}
		value += unit

		//var prefixedValue = window.Modernizr.prefixedCSSValue(name, value)
		//var prefixedValue = value
		var rule = ruleName + ':' + value //+ (prefixedValue !== false? prefixedValue: value)

		if (cache)
			cache.add(rule)

		rules.push(rule)
	}
	var cls = cache? cache.classify(rules): ''
	if (cls !== this._class) {
		var classList = element.classList
		if (this._class !== '')
			classList.remove(this._class)
		this._class = cls
		if (cls !== '')
			classList.add(cls)
	}
	this.dom.setAttribute('style', rules.join(';'))
}

ElementPrototype.append = function(el) {
	this.dom.appendChild((el instanceof exports.Element)? el.dom: el)
}

ElementPrototype.discard = function() {
	_globals.core.RAIIEventEmitter.prototype.discard.apply(this)
	this.remove()
}

ElementPrototype.remove = function() {
	var dom = this.dom
	dom.parentNode.removeChild(dom)
}

exports.Window = function(context, dom) {
	_globals.core.RAIIEventEmitter.apply(this)
	this._context = context
	this.dom = dom

	registerGenericListener(this)
}

var WindowPrototype = exports.Window.prototype = Object.create(_globals.core.RAIIEventEmitter.prototype)
WindowPrototype.constructor = exports.Window

WindowPrototype.width = function() {
	return this.dom.innerWidth
}

WindowPrototype.height = function() {
	return this.dom.innerHeight
}

WindowPrototype.scrollY = function() {
	return this.dom.scrollY
}

exports.getElement = function(tag) {
	var tags = document.getElementsByTagName(tag)
	if (tags.length != 1)
		throw new Error('no tag ' + tag + '/multiple tags')
	return new exports.Element(this, tags[0])
}

exports.init = function(ctx) {
	var options = ctx.options
	var prefix = ctx._prefix
	var divId = options.id
	var tag = options.tag || 'div'

	if (prefix) {
		prefix += '-'
		log('Context: using prefix', prefix)
	}

	var win = new _globals.html5.html.Window(ctx, window)
	ctx.window = win
	var w, h

	var html = exports
	var div = document.getElementById(divId)
	var topLevel = div === null
	if (!topLevel) {
		div = new html.Element(ctx, div)
		w = div.width()
		h = div.height()
		log('Context: found element by id, size: ' + w + 'x' + h)
		win.on('resize', function() { ctx.width = div.width(); ctx.height = div.height(); });
	} else {
		w = win.width();
		h = win.height();
		log("Context: window size: " + w + "x" + h);
		div = html.createElement(ctx, tag)
		div.dom.id = divId
		win.on('resize', function() { ctx.width = win.width(); ctx.height = win.height(); });
		var body = html.getElement('body')
		body.append(div);
	}

	ctx._textCanvas = html.createElement(ctx, 'canvas')
	div.append(ctx._textCanvas)
	ctx._textCanvasContext = ('getContext' in ctx._textCanvas.dom)? ctx._textCanvas.dom.getContext('2d'): null

	ctx.element = div
	ctx.width = w
	ctx.height = h

	win.on('scroll', function(event) { ctx.scrollY = win.scrollY(); });

	var onFullscreenChanged = function(e) {
		var state = document.fullScreen || document.mozFullScreen || document.webkitIsFullScreen;
		ctx.fullscreen = state
	}
	'webkitfullscreenchange mozfullscreenchange fullscreenchange'.split(' ').forEach(function(name) {
		div.on(name, onFullscreenChanged)
	})

	win.on('keydown', function(event) {
		var handlers = core.forEach(ctx, _globals.core.Item.prototype._enqueueNextChildInFocusChain, [])
		var n = handlers.length
		for(var i = 0; i < n; ++i) {
			var handler = handlers[i]
			if (handler._processKey(event)) {
				event.preventDefault();
				break
			}
		}
	}) //fixme: add html.Document instead

	var system = ctx.system
	//fixme: port to event listener?
	window.onfocus = function() { system.pageActive = true }
	window.onblur = function() { system.pageActive = false }

	system.screenWidth = window.screen.width
	system.screenHeight = window.screen.height
}

exports.createElement = function(ctx, tag) {
	return new exports.Element(ctx, tag)
}

exports.initImage = function(image) {
	var tmp = new Image()
	image._image = tmp
	image._image.onerror = image._onError.bind(image)

	image._image.onload = function() {
		image.sourceWidth = tmp.naturalWidth
		image.sourceHeight = tmp.naturalHeight
		var natW = tmp.naturalWidth, natH = tmp.naturalHeight

		if (!image.width)
			image.width = natW
		if (!image.height)
			image.height = natH

		if (image.fillMode !== image.PreserveAspectFit) {
			image.paintedWidth = image.width
			image.paintedHeight = image.height
		}

		var style = {'background-image': 'url("' + image.source + '")'}
		switch(image.fillMode) {
			case image.Stretch:
				style['background-repeat'] = 'no-repeat'
				style['background-size'] = '100% 100%'
				break;
			case image.TileVertically:
				style['background-repeat'] = 'repeat-y'
				style['background-size'] = '100% ' + natH + 'px'
				break;
			case image.TileHorizontally:
				style['background-repeat'] = 'repeat-x'
				style['background-size'] = natW + 'px 100%'
				break;
			case image.Tile:
				style['background-repeat'] = 'repeat-y repeat-x'
				style['background-size'] = 'auto'
				break;
			case image.PreserveAspectCrop:
				style['background-repeat'] = 'no-repeat'
				style['background-position'] = 'center'
				style['background-size'] = 'cover'
				break;
			case image.Pad:
				style['background-repeat'] = 'no-repeat'
				style['background-position'] = '0% 0%'
				style['background-size'] = 'auto'
				break;
			case image.PreserveAspectFit:
				style['background-repeat'] = 'no-repeat'
				style['background-position'] = 'center'
				style['background-size'] = 'contain'
				var w = image.width, h = image.height
				var targetRatio = 0, srcRatio = natW / natH

				if (w && h)
					targetRatio = w / h

				if (srcRatio > targetRatio && w) { // img width aligned with target width
					image.paintedWidth = w;
					image.paintedHeight = w / srcRatio;
				} else {
					image.paintedHeight = h;
					image.paintedWidth = h * srcRatio;
				}
				break;
		}
		image.style(style)

		image.status = image.Ready
	}
}

exports.loadImage = function(image) {
	image._image.src = image.source
}

exports.initText = function(text) {
	text.element.addClass(text._context.getClass('core-text'))
}

var layoutTextSetStyle = function(text, style) {
	switch(text.verticalAlignment) {
		case text.AlignTop:		text._topPadding = 0; break
		case text.AlignBottom:	text._topPadding = text.height - text.paintedHeight; break
		case text.AlignVCenter:	text._topPadding = (text.height - text.paintedHeight) / 2; break
	}
	style['padding-top'] = text._topPadding
	style['height'] = text.height - text._topPadding
	text.style(style)
}

exports.setText = function(text, html) {
	text.element.setHtml(html)
}

exports.layoutText = function(text) {
	var ctx = text._context
	var textCanvasContext = ctx._textCanvasContext
	var wrap = text.wrapMode !== _globals.core.Text.NoWrap
	var element = text.element

	var dom = element.dom

	var isHtml = text.text.search(/[\<\&]/) >= 0 //dubious check
	if (!wrap && textCanvasContext !== null && !isHtml) {
		var styles = getComputedStyle(dom)
		var fontSize = styles.getPropertyValue('line-height')
		var units = fontSize.slice(-2)
		if (units === 'px') {
			var font = styles.getPropertyValue('font')
			textCanvasContext.font = font
			var metrics = textCanvasContext.measureText(text.text)
			text.paintedWidth = metrics.width
			text.paintedHeight = parseInt(fontSize)
			layoutTextSetStyle(text, {})
			return
		}
	}

	var removedChildren = []

	text.children.forEach(function(child) {
		var childNode = child.element.dom
		if (childNode.parentNode === dom) {
			dom.removeChild(childNode)
			removedChildren.push(childNode)
		}
	})

	if (!wrap)
		text.style({ width: 'auto', height: 'auto', 'padding-top': 0 }) //no need to reset it to width, it's already there
	else
		text.style({ 'height': 'auto', 'padding-top': 0})

	//this is the source of rounding error. For instance you have 186.3px wide text, this sets width to 186px and causes wrapping
	text.paintedWidth = element.fullWidth()
	text.paintedHeight = element.fullHeight()

	//this makes style to adjust width (by adding this value), and return back _widthAdjust less
	element._widthAdjust = 1

	var style
	if (!wrap)
		style = { width: text.width, height: text.height } //restore original width value (see 'if' above)
	else
		style = {'height': text.height }

	layoutTextSetStyle(text, style)

	removedChildren.forEach(function(child) {
		dom.appendChild(child)
	})
}

exports.run = function(ctx, onloadCallback) {
	ctx.window.on('load', function() {
		onloadCallback()
	})
}

var Modernizr = window.Modernizr

exports.capabilities = {
	csstransforms3d: Modernizr.csstransforms3d,
	csstransforms: Modernizr.csstransforms,
	csstransitions: Modernizr.csstransitions
}

exports.requestAnimationFrame = Modernizr.prefixed('requestAnimationFrame', window)	|| function(callback) { return setTimeout(callback, 0) }
exports.cancelAnimationFrame = Modernizr.prefixed('cancelAnimationFrame', window)	|| function(id) { return clearTimeout(id) }

exports.enterFullscreenMode = function(el) { return Modernizr.prefixed('requestFullscreen', el.dom)() }
exports.exitFullscreenMode = function() { return window.Modernizr.prefixed('exitFullscreen', document)() }
exports.inFullscreenMode = function () { return !!window.Modernizr.prefixed('fullscreenElement', document) }

return exports;
} )()


return exports;
} )();
try {
	var l10n = {}

	var context = qml._context = new qml.core.Context(null, false, {id: 'qml-context-app', prefix: '', l10n: l10n})
	var closure = {}

	context.__create(closure)
	context.__setup(closure)
	closure = undefined
	context.init()
	context.start(new qml.src.UiApp(context))
	context.run()
} catch(ex) { log("qml initialization failed: ", ex, ex.stack) }
