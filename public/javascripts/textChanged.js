function textChanged() {
    var maxLen = 140;
    var left = maxLen - this.getValue().length;
    $('char-count').update(left);
};
