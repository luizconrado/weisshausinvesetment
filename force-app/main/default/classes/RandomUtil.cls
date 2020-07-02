public inherited sharing class RandomUtil {
    public static String getUUID() {
        Blob b = Crypto.generateAesKey(128);
        String h = EncodingUtil.convertToHex(b);
        String guid = h.substring(0, 8) + '-' + h.substring(8, 12) + '-' + h.substring(12, 16) + '-' + h.substring(16, 20) + '-' + h.substring(20);
        return guid;
    }
    public static Integer randomNumber( Integer maxValue) {
        return Integer.valueOf(Math.random() * maxValue);
    }
    public static String randomString( Integer length) {
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String result = '';
        while (result.length() < length) {
            Integer i = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            result += chars.substring(i, i + 1);
        }
        return result;
    }
}