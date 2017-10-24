;
var rest = {
    createrequest : function (method, url, param, delegate, headers) {
        var _this = this;
        //
        // create request object
        //
        var xhr = new XMLHttpRequest();
        //
        // 
        //
        xhr.rest = {
            delegate: (delegate != undefined) ? delegate : null,
            progress: 0,
            status: 0,
            statustext: ""
        };
        if ( delegate ) {
            //
            // hook events
            //
            if ( delegate.onloadend !== undefined ) {
                if (xhr.onloadend) {
                    if ( delegate.onload !== undefined ) {
                        xhr.addEventListener('load', function (e) {
                            delegate.onload(e);
                        }, false);
                    }
                    xhr.addEventListener('loadend', function (e) {
                        delegate.onloadend(e);
                    }, false);
                } else {
                    xhr.addEventListener('load', function (e) {
                        delegate.onloadend(e);
                    }, false);
                }
            }

            if ( delegate.onloadstart !== undefined ) {
                xhr.addEventListener('loadstart', function (e) {
                    delegate.onloadstart(e);
                }, false);
            }

            if ( delegate.onprogress !== undefined ) {
                xhr.addEventListener('progress', function (e) {
                    delegate.onprogress(e);
                }, false);
            }

            if ( delegate.onabort !== undefined ) {
                xhr.addEventListener('abort', function (e) {
                    delegate.onabort(e);
                }, false);
            }

            if ( delegate.ontimeout !== undefined ) {
                xhr.addEventListener('timeout', function (e) {
                    delegate.ontimeout(e);
                }, false);
            }

            if ( delegate.onerror !== undefined ) {
                xhr.addEventListener('error', function (e) {
                    delegate.onerror(e);
                }, false);
            }
        }
        //
        // build query string
        //
        var query = "";
        for (var key in param) {
            if (query.length == 0) {
                query += '?';
            } else {
                query += '&';
            }
            query += key + '=' + escape(param[key]);
        }
        //
        // open request
        //
        xhr.open(method, url + query, true);
        //
        // add optional headers
        //
        if (headers) {
            for (name in headers) {
                xhr.setRequestHeader(name, headers[name]);
            }
        }
        //
        //
        //
        return xhr;
    },
    //
    // 
    //
    get : function( url, delegate, headers ) {
        //
        // create request
        //
        var request = rest.createrequest("GET", url, {}, delegate, headers);
        //
        // send
        // 
        request.send();
        return request;
    },
    post : function( url, data, delegate, headers, raw ) {
        //
        // create request
        //
        if (!headers) headers = {};
        if (!headers['Content-Type']&&!raw) headers['Content-Type'] = 'application/json'; // default to JSON request body
        var request = rest.createrequest("POST", url, {}, delegate, headers);
        //
        // send data
        // 
        //
        if ( raw ) {
            request.send(data);
        } else {
            request.send(JSON.stringify(data));
        }
        return request;
    },
    put : function( url, data, delegate, headers, raw ) {
        //
        // create request
        //
        if (!headers) headers = {};
        if (!headers['Content-Type']&&!raw) headers['Content-Type'] = 'application/json'; // default to JSON request body
        var request = rest.createrequest("PUT", url, {}, delegate, headers);
        //
        // send data
        // 
        if ( raw ) {
            request.send(data);
        } else {
            request.send(JSON.stringify(data));
        }
        return request;
    },
    delete : function( url, delegate, headers ) {
        //
        // create request
        //
        var request = rest.createrequest("DELETE", url, {}, delegate, headers );
        //
        // send
        // 
        request.send();
        return request;
    },
    //
    //
    //
    iserror : function( evt ) {
        return evt.target.status >= 400;
    },
    getresponse : function( evt ) {
        var request = evt.target;
        return response = request.response === undefined ? request.responseText : request.response;
    },
    parseresponse : function( evt ) {
        var self = rest;
        var response = self.getresponse( evt );
        try {
            var json = JSON.parse( response );
            return json;
        } catch( err ) {
            return undefined;
        }
    },
    formaterror : function( evt ) {
        var self = rest;
        var request = evt.target;
        var code = request.status;
        var text = request.statusText;
        var description = self.parseresponse( evt );
        return code + ' : ' + text +  ( description && description.message ? ' : ' + description.message : '' );
    } 
};
//
//
//
( function( w, d ) {
    //
    // hook toolbar items
    //
    var back = d.querySelector('#back');
    if ( back ) {
        back.onclick = function() {
            var location = w.location.toString();
            w.location = location.substring(0,location.lastIndexOf('/'));
        }
    }
    var add = d.querySelector('#add');
    if ( add ) {
        var category = add.getAttribute('data-category');
        var id = add.getAttribute('data-item');
        if ( id ) {
            //
            // new block menu
            //
            add.onclick = function() {
                d.querySelector('.menu').classList.toggle('active');
            }
            w.addEventListener('click',function(){
                var menu = d.querySelector('.menu');
                if( menu.classList.contains('active') ) {
                    menu.classList.remove('active');
                }
            },true);
            var menuItems = d.querySelectorAll('.menu-item');
            for ( var i = 0; i < menuItems.length; ++i ) {
                 (function(item){
                    var type = item.getAttribute('data-type');
                    if ( type ) {
                        item.onclick = function() {
                            w.location = '/admin/' + category + '/' + id + '/-1?type=' + type;
                        }
                    }
                })(menuItems[i]);
            }
       } else {
            //
            // new document
            //
            add.onclick = function() {
                rest.post('/admin/' + category, { title: 'New document' }, {
                    onloadend: function(evt) {
                        //
                        // load new document
                        //
                        var response = rest.parseresponse(evt);
                        w.location = '/admin/' + category + '/' + response.item._id;
                    },
                    onerror: function(error) {
                        alert( error );
                    }
                } );
            };
        }
    }
    var save = d.querySelector('#save');
    if ( save ) {
        save.onclick = function() {
            var category    = save.getAttribute('data-category');
            var item        = save.getAttribute('data-item');
            var index       = save.getAttribute('data-index'); 
            if ( index ) {
                var endpoint    = '/admin/' + category + '/' + item + '/' + index;
                var block = {
                    type: save.getAttribute('data-type'),
                    title: d.querySelector('#title').value,
                    content: d.querySelector('#content').value,
                    tags: d.querySelector('#tags').value.split()
                };
                rest.put( endpoint, block, {
                    onloadend: function(evt) {
                        //
                        // return to document
                        //
                        w.location = '/admin/' + category + '/' + item;
                    },
                    onerror: function(error) {
                        alert( error );
                    }
                });
            } else {
                var endpoint    = '/admin/' + category + '/' + item;
                var blocks = [];
                var blockList = d.querySelectorAll('.block');
                for ( var i = 0; i < blockList.length; ++i ) {
                    (function(block){
                        blocks.push({
                            title: block.getAttribute('data-title'),
                            content: block.getAttribute('data-content'),
                            tags: block.getAttribute('data-tags').split()
                        });
                    })( blockList[i]);
                }
                var document = {
                    title: d.querySelector('#title').value,
                    blocks: blocks
                };
                rest.put( endpoint, document, {
                    onloadend: function(evt) {
                        //
                        // return to document
                        //
                        w.location.reload();
                    },
                    onerror: function(error) {
                        alert( error );
                    }
                });
            }
        };
    }
    var list = d.querySelector('.list');
    if ( list ){
        //
        // hook list items
        //
        if ( list.firstChild.classList.contains('list-item') ) {
            var listItems = list.querySelectorAll('.list-item');
            for ( var i = 0; i < listItems.length; ++i ) {
                ( function( item ) {
                    var id = item.getAttribute('data-id');
                    item.onclick = function() {
                        if ( id ) {
                            w.location = w.location + '/' + id;
                        }
                    };
                    var del = item.querySelector('.delete');
                    if ( del ) {
                        del.onclick = function(evt) {
                            if ( confirm('Are you sure you want to delete this document?') ) {
                                var endpoint = w.location + '/' + id;
                                rest.delete(endpoint,{
                                    onloadend: function(evt) {
                                        //
                                        // return to document
                                        //
                                        w.location.reload();
                                    },
                                    onerror: function(error) {
                                        alert( error );
                                    }
                                });
                                evt.stopPropagation();
                            }
                        }
                    }
                })(listItems[ i ]);
            }
        } else if ( list.firstChild.classList.contains('block') ) {
           var blocks = list.querySelectorAll('.block');
            for ( var i = 0; i < blocks.length; ++i ) {
                ( function( block ) {
                    var category    = block.getAttribute('data-category');
                    var item        = block.getAttribute('data-item');
                    var index       = block.getAttribute('data-index');
                    block.onclick = function() {
                        w.location = '/admin/' + category + '/' + item + '/' + index;
                    };
                    var del = block.querySelector('.delete');
                    if( del ) {
                        del.onclick = function( evt ) {
                            if ( confirm('Are you sure you want to delete this block?') ) {
                                var endpoint = w.location + '/' + index;
                                rest.delete(endpoint,{
                                    onloadend: function(evt) {
                                        //
                                        // return to document
                                        //
                                        w.location.reload();
                                    },
                                    onerror: function(error) {
                                        alert( error );
                                    }
                                });
                                evt.stopPropagation();
                            }
                        };
                    }
                })(blocks[ i ]);
            }
            
        }
    }
    //
    // hook editor controls
    //
    var content = d.querySelector( '#content' );
    if( content ) {
        var preview = d.querySelector( '#preview' );
        if ( preview ) {
            content.addEventListener( 'input', function() {
                preview.innerHTML = content.value;
            });
        }
    }
    //
    // drag and drop
    //
    var dropArea = d.querySelector('.drop-area');
    if ( dropArea ) {
        function dragEnter(evt) {
            dropArea.classList.add('active');
            evt.stopPropagation();
            evt.preventDefault();
            return false;
        }
        function dragOver(evt) {
            evt.stopPropagation();
            evt.preventDefault();
            evt.dataTransfer.dropEffect = 'copy';
            return false;
        }
        function dragLeave(evt) {
            dropArea.classList.remove('active');
            return false;
        }
        function drop(evt) {
            evt.preventDefault();
            evt.stopPropagation();
            dropArea.classList.remove('active');
            var target = dropArea.querySelector('img') || dropArea.querySelector('video');
            if ( target ) {
                function pad(n, width=3, z=0) {return (String(z).repeat(width) + String(n)).slice(String(n).length)};
                function toASCII( str ) { var ascii = new Uint8Array(str.length); for ( var i = 0; i < str.length; ++i ) ascii[i] = str.charCodeAt(i); return ascii };
                function makeCommandHeader( selector, guid, size ) {
                    var header  = new ArrayBuffer(size);
                    var dv      = new DataView(header);
                    var offset = 0;
                    toASCII(selector).forEach( function(c) {
                        dv.setUint8( offset, c );
                        offset++;
                    });
                    toASCII(guid).forEach( function(c) {
                        dv.setUint8( offset, c );
                        offset++;
                    });
                    return header;
                }
                var file = evt.dataTransfer.files[0];
                console.log( file.name + ':' + file.size + ':' + file.type );
                //
                //
                //
                var guid = pad(Date.now(),16,'0');
                var filename = file.name;
                var filesize = file.size;
                var ws = new WebSocket('ws://aftertrauma.uk:4000');
                ws.binaryType = 'arraybuffer';
                ws.onmessage = function(evt) {
                    if ( typeof evt.data === 'string' ) {
                        console.log( evt.data );
                        var response = JSON.parse(evt.data);
                        if ( response.status === "DONE" ) {
                            target.src = response.destination;
                        }
                    } else {
                        var dv = new DataView(evt.data);
                        //
                        // TODO: process progress and completion
                        //
                        
                    }
                }
                ws.onopen = function() {
                    //
                    // write header
                    // command : 0-3 = selector, 4-19 = uuid, 20-23 = stage ( 'head' | 'chnk' )
                    //
                    var command = makeCommandHeader( 'upld', guid, 20 + 4 + 2 + 4 + filename.length );
                    var dv = new DataView(command);
                    var offset = 20;
                    toASCII('head').forEach( function(c) {
                        dv.setUint8( offset, c );
                        offset++;
                    }); 
                    dv.setUint16(offset,filename.length);
                    offset += 2;
                    toASCII(filename).forEach( function(c) {
                        dv.setUint8( offset, c );
                        offset++;
                    }); 
                    dv.setUint32(offset,filesize);
                    ws.send(command);
                    //
                    //
                    //
                    var remaining = filesize;
                    var chunkSize = 2048;
                    var fileOffset = 0;
                    var sent = 0;
                    while( remaining > 0 ) {
                        var reader = new FileReader();
                        reader.onloadend = function(evt) {
                            if (evt.target.readyState == FileReader.DONE) { // DONE == 2
                                //
                                // write chunk
                                //
                                var buffer = evt.target.result;
                                console.log( 'read ' + buffer.byteLength + ' bytes' );
                                command = makeCommandHeader( 'upld', guid, 24 + buffer.byteLength );
                                dv = new DataView(command);
                                offset = 20;
                                toASCII('chnk').forEach( function(c) {
                                    dv.setUint8( offset, c );
                                    offset++;
                                }); 
                                var source = new Int8Array(buffer);
                                var destination = new Int8Array(command);
                                for ( var i = 0; i < buffer.byteLength; ++i) {
                                    destination[ offset + i ] = source[ i ];
                                }
                                //destination.set( source, offset );
                                ws.send(command);
                                sent += buffer.byteLength;
                                if ( sent >= filesize ) {
                                    console.log('done');
                                }
                           }
                        }; 
                        reader.readAsArrayBuffer(file.slice(fileOffset,fileOffset+chunkSize));
                        fileOffset += chunkSize;
                        remaining -= chunkSize;
                    }
                }
            }
            return false;
        }
        dropArea.addEventListener("dragenter", dragEnter, false);
        dropArea.addEventListener("dragleave", dragLeave, false);
        dropArea.addEventListener("dragover", dragOver, false);
        dropArea.addEventListener("drop", drop, false);
    }
    
})(window,document);