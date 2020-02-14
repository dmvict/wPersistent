( function _Collection_s_( ) {

'use strict';

//

let _ = _global_.wTools;
let Parent = null;
let Self = function wCollection( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Collection';

// --
// inter
// --

function init( o )
{
  let collection = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( collection );
  Object.preventExtensions( collection );

  if( o )
  collection.copy( o );

  /* */

  _.sure( _.strDefined( collection.name ), `Expects name of collection {- name -}` );
  _.assert( collection.repo instanceof _.persistent.Repo );

  if( collection.kind === null )
  {
    let read = collection.structureRead();
    if( _.arrayIs( read ) )
    collection.kind = 'array';
    else
    collection.kind = 'map';
  }

  _.sure( _.longHas( [ 'array', 'map' ], collection.kind ), `Expects kind of collection {- kind -}, but got ${collection.kind}` );
}

//

function filePathGet()
{
  let collection = this;
  let repo = collection.repo;
  let path = _.fileProvider.path;
  let filePath = path.join( path.dirUserHome(), repo.name, collection.name );
  return filePath;
}

//

function _collection( o )
{
  let collection = this;
  let repo = collection.repo;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.name ) );

  return _.persistent.Collection
  ({
    repo : repo,
    name : o.name,
    kind : o.kind,
    selector : o.selector,
  });
}

//

function collection( collectionName )
{
  let collection = this;
  let repo = collection.repo;

  _.assert( arguments.length === 1 );

  return collection._collection
  ({
    name : collection.name,
    kind : 'array',
    selector : _.path.join( collection.selector, collectionName )
  });
}

//

function array( collectionName )
{
  let collection = this;
  let repo = collection.repo;

  _.assert( arguments.length === 1 );

  return collection._collection
  ({
    name : collection.name,
    kind : 'array',
    selector : _.path.join( collection.selector, collectionName )
  });
}

//

function map( collectionName )
{
  let collection = this;
  let repo = collection.repo;

  _.assert( arguments.length === 1 );

  return collection._collection
  ({
    name : collection.name,
    kind : 'map',
    selector : _.path.join( collection.selector, collectionName )
  });
}

//

function structureAppend( structure )
{
  let collection = this;
  let path = _.fileProvider.path;
  let read = null;

  _.assert( arguments.length === 1 );

  read = collection.structureRead();
  read.push( structure );

  collection.structureWrite( read );

  return collection;
}

//

function structurePrepend( structure )
{
  let collection = this;
  let path = _.fileProvider.path;
  let read = null;

  _.assert( arguments.length === 1 );

  read = collection.structureRead();
  read.unshift( structure );

  collection.structureWrite( read );

  return collection;
}

//

function structureInsert( key, structure )
{
  let collection = this;
  let path = _.fileProvider.path;
  let read = null;

  _.assert( arguments.length === 2 );

  read = collection.structureRead();
  read[ key ] = structure;

  collection.structureWrite( read );

  return collection;
}

//

function structureWrite( structure )
{
  let collection = this;
  let path = _.fileProvider.path;
  let filePath = collection.filePathGet();

  _.assert( arguments.length === 1 );

  if( _.fileProvider.isDir( filePath ) )
  throw _.err( `${filePath} is directory, cant overwrite!` );
  _.fileProvider.fileWrite( filePath, _.toJson( structure ) );

  return collection;
}

//

function structureRead()
{
  let collection = this;
  let path = _.fileProvider.path;
  let filePath = collection.filePathGet();
  let read = null;

  _.assert( arguments.length === 0 );

  if( !_.fileProvider.isTerminal( filePath ) )
  {
    if( collection.kind === 'array' )
    return [];
    else
    return Object.create( null );
  }

  collection.read = _.fileProvider.fileRead({ filePath : filePath, encoding : 'json' });

  if( collection.selector === '/' )
  return collection.read;
  else
  return _.select( collection.read, collection.selector );
}

//

function clean()
{
  let collection = this;
  let path = _.fileProvider.path;

  let filePath = collection.filePathGet();

  if( _.fileProvider.isDir( filePath ) )
  throw _.err( `${filePath} is directory, cant overwrite!` );
  _.fileProvider.fileDelete( filePath );

  return collection;
}

// --
// relations
// --

let Composes =
{
  kind : null,
  name : null,
}

let Aggregates =
{
}

let Associates =
{
  repo : null,
}

let Restricts =
{
  read : null,
  selector : '/',
}

let Statics =
{
}

let Forbids =
{
}

let Accessors =
{
}

// --
// declare
// --

let Proto =
{

  // inter

  init,
  filePathGet,

  array,
  map,

  structureAppend,
  structurePrepend,
  structureInsert,
  structureWrite,
  structureRead,
  clean,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

// --
// export
// --

_.persistent[ Self.shortName ] = Self;
if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
