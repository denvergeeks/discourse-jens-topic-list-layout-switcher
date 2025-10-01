import { apiInitializer } from "discourse/lib/api";
import TopicListReplyCountIcon from "../components/topic-list-reply-count-icon";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("topic-list-before-reply-count", TopicListReplyCountIcon);
});
