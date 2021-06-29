
class TopicInfoModel {
  final String title;                                 //回复内容
  final String titleLink;                             //内容链接
  final String creatorImg ;                            //创建者头像
  final String creatorName;                           //创建者名称
  final String creatTime;                             //创建时间
  final String creatorLink;                           //创建者链接
  final String lastReplyName;                         //最后回复者名称
  final String lastReplyLink;                         //最后回复者链接
  final String replyDescription;                      //回复时间
  final String node;                                  //所属节点
  final int replyCount;                             //回复数
  final String contentHtml;                           //html内容
  final String isFavorite;                         //是否收藏
  final String favoriteURL;                           //收藏操作
  final List<String> images;                    //html中的image链接

  const TopicInfoModel(this.title,
      this.titleLink,
      this.node,
      this.creatorImg,
      this.creatorName,
      this.creatorLink,
      this.lastReplyName,this.lastReplyLink,
      this.replyCount,this.replyDescription,this.creatTime,this.contentHtml,this.isFavorite,this.favoriteURL,this.images);
}