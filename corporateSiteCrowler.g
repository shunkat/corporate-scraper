function main() {
  run(1)
}

function run(n) {
  //スクレイピングスタートするURL
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("scraper");
  const lastRow = sheet.getLastRow();
  //①列の先頭行から下方向に取得する
  if (firstRow >= lastRow) return;
  var firstRow = n;
  Logger.log(firstRow)
  sheet.getRange(firstRow,3,1,3).setValues([["処理中","処理中","処理中"]]);
  const readRange = sheet.getRange(firstRow,2);
  const readValue = readRange.getValues();
  try {
    const url = readValue
    var html = UrlFetchApp.fetch(url).getContentText('UTF-8');
    const isWP = (html.indexOf("wp-content") != -1);
    value = [isWP.toString(),getSpeed(url,"desktop"), getSpeed(url, "mobile")];
  } catch (ex) {
    Logger.log(ex.toString())
    value = ["URLに問題がありそう","不明","不明"];
  }
  sheet.getRange(firstRow,3,1,3).setValues([value]);
  return n
}

function getSpeed(url, device) {
  const speed = UrlFetchApp.fetch("https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
        + url
        + "&locale=ja"
        + "&strategy"
        + device
    )
  const score = JSON.parse(speed)["lighthouseResult"]["categories"]["performance"]["score"]
  Logger.log(score)
  return score
}


// doGet関数をコード.gsに追加する
function doGet() {
  return HtmlService.createHtmlOutputFromFile('heiretu');
}
