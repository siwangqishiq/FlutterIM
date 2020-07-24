import 'dart:collection';

///
///固定大小的LruCache
/// by panyi
///

class LruCache<K,V>{
  static const int DEFAULT_CACHE_SIZE = 256;

  LinkedHashMap _map = LinkedHashMap();
  int _cacheSize = DEFAULT_CACHE_SIZE;

  LruCache({cacheSize: DEFAULT_CACHE_SIZE}){
    _cacheSize = cacheSize;
  }

  void put(K key , V value){
    _map[key] = value;
    _afterPutMap();
  }

  V get(K key){
    V result = _map[key];
    return result;
  }

  void _afterPutMap(){
    while(_map.length > _cacheSize){
      var keyIter = _map.keys;
      //print(keyIter);
      _map.remove(keyIter.first);
      //print("remove elem $rmV");
    }//end while
  }
}



