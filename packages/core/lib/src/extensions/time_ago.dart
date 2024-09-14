extension DateTimeExtension on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) return '< 1m ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';

    if (difference.inHours < 24) return '${difference.inHours}h ago';

    if (difference.inDays < 30) return '${difference.inDays}d ago';

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }

    final years = (difference.inDays / 365).floor();
    return '${years}y ago';
  }
}
