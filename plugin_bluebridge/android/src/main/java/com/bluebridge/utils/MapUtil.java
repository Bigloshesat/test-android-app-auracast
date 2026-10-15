package com.bluebridge.utils;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class MapUtil {

    public static <T> List<T> mapToList(Map<String, T> map) {
        List<T> list = new ArrayList();
        Iterator iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry entry = (Map.Entry) iterator.next();
            list.add((T) entry.getValue());
        }
        return list;
    }

}
