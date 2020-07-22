import 'dart:collection';

///
///固定大小的LruCache
/// by panyi
///

class LruCache<K,V>{
  static const int DEFAULT_CACHE_SIZE = 256;

  LinkedHashMap _map = LinkedHashMap();
  int _cacheSize = DEFAULT_CACHE_SIZE;

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
      Iterable<V> keyIter = _map.values;
      _map.remove(keyIter.first);
    }
  }
}



