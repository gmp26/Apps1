
describe('twitterfy filter', function() {
  beforeEach(module('app'));
  return it('Twitter username should be prepended with the @ sign', inject([
    'twitterfyFilter', function(twitterfy) {
      var twitterHandle, twitterfied;
      twitterHandle = 'CaryLandholt';
      twitterfied = twitterfy(twitterHandle);
      expect(twitterfied).not.toEqual(twitterHandle);
      return expect(twitterfied).toEqual("@" + twitterHandle);
    }
  ]));
});
