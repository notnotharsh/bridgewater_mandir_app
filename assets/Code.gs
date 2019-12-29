// The following code is meant to go up on the Google sheet associated with this app at bit.ly/mandirgiftshopsheet. It isn't part of the app itself, but is the code meant to handle app data.

function updateJSON() {
  var namesList = new Array();
  var sheets = SpreadsheetApp.getActiveSpreadsheet().getSheets();
  for (var i = 0; i < sheets.length; i++) {
    namesList.push(sheets[i].getName());
  }
  var namesListJSON = {"sheets": namesList};
  var url = "http://api.myjson.com/bins/1d7urg";
  var options = {
    "method": "put",
    "payload": JSON.stringify(namesListJSON),
    "contentType": "application/json; charset=utf-8",
    "muteHttpExceptions": true
  };
  var response = UrlFetchApp.fetch(url, options);
}


function sheetName() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getActiveSheet();
  return sheet.getName();
}

function mergeLists(list1, list2) {
  var merged = [];
  for (var i = 0; i < list1.length; i++) {
    merged.push(list1[i]);
  }
  for (var i = 0; i < list2.length; i++) {
    if (!(list1.indexOf(list2[i]) != -1)) {
      merged.push(list2[i]);
    }
  }
  return merged;
}

function mergeMaps(map1, map2) {
  var merged = {};
  var mergedKeys = mergeLists(Object.keys(map1), Object.keys(map2));
  for (var i = 0; i < mergedKeys.length; i++) {
    var in1 = map1.hasOwnProperty(mergedKeys[i]);
    var in2 = map2.hasOwnProperty(mergedKeys[i]);
    if (in1) {
      if (in2) {
        merged[mergedKeys[i]] = (parseInt(map1[mergedKeys[i]]) + parseInt(map2[mergedKeys[i]])).toString();
      } else {
        merged[mergedKeys[i]] = map1[mergedKeys[i]];
      }
    } else {
      if (in2) {
        merged[mergedKeys[i]] = map2[mergedKeys[i]];
      } else {
        merged[mergedKeys[i]] = [];
      }
    }
  }
  return merged;
}

function metaMergeMaps(map1, map2) {
  var merged = {};
  var mergedKeys = mergeLists(Object.keys(map1), Object.keys(map2));
  for (var i = 0; i < mergedKeys.length; i++) {
    var in1 = map1.hasOwnProperty(mergedKeys[i]);
    var in2 = map2.hasOwnProperty(mergedKeys[i]);
    if (in1) {
      if (in2) {
        merged[mergedKeys[i]] = mergeMaps(map1[mergedKeys[i]], map2[mergedKeys[i]]);
      } else {
        merged[mergedKeys[i]] = map1[mergedKeys[i]];
      }
    } else {
      if (in2) {
        merged[mergedKeys[i]] = map2[mergedKeys[i]];
      } else {
        merged[mergedKeys[i]] = [];
      }
    }
  }
  return merged;
}

function JSONArrayToArrayArray(jli) {
  var li = JSON.parse(jli);
  var merged = {};
  for (var i = 0; i < li.length; i++) {
    merged = metaMergeMaps(merged, li[i]);
  }
  var arr = [];
  for (var i = 0; i < Object.keys(merged).length; i++) {
    for (var j = 0; j < Object.keys(merged[Object.keys(merged)[i]]).length; j++) {
      var toAdd = []
      toAdd.push(Object.keys(merged)[i]);
      toAdd.push(Object.keys(merged[Object.keys(merged)[i]])[j]);
      toAdd.push(merged[Object.keys(merged)[i]][Object.keys(merged[Object.keys(merged)[i]])[j]]);
      arr.push(toAdd);
    }
  }
  return arr;
}
