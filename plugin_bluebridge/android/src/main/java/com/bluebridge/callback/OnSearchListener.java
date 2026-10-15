package com.bluebridge.callback;

import com.inuker.bluetooth.library.search.SearchResult;

import java.util.List;

public interface OnSearchListener {

    void onResult(List<SearchResult> devices, int status);
}