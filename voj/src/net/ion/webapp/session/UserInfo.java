package net.ion.webapp.session;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class UserInfo<K,V> implements Map<K,V>{
	Map<K, V> map = null;
	public UserInfo(Map<K, V> map){
		this.map = map;
	}
	@Override
	public V get(Object key) {
		// TODO Auto-generated method stub
		return map.get(key);
	}

	@Override
	public int size() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean isEmpty() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean containsKey(Object key) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean containsValue(Object value) {
		// TODO Auto-generated method stub
		return false;
	}


	@Override
	public V put(K key, V value) {
    	throw new RuntimeException("You can not modify user information.");
	}

	@Override
	public V remove(Object key) {
    	throw new RuntimeException("You can not modify user information.");
	}

	@Override
	public void putAll(Map<? extends K, ? extends V> m) {
    	throw new RuntimeException("You can not modify user information.");
	}

	@Override
	public void clear() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Set<K> keySet() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<V> values() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Set<java.util.Map.Entry<K, V>> entrySet() {
		// TODO Auto-generated method stub
		return null;
	}

}
