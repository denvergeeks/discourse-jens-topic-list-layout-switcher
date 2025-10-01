import { apiInitializer } from "discourse/lib/api";
import TopicListLayoutToggle from "../components/topic-list-layout-toggle";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("before-create-topic-button", TopicListLayoutToggle);
});
