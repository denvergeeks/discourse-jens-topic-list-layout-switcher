import { apiInitializer } from "discourse/lib/api";
import TopicListImage from "../components/topic-list-image";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("topic-list-main-link-bottom", TopicListImage);
});
