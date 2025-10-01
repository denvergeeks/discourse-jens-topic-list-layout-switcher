import { apiInitializer } from "discourse/lib/api";
import TopicListExcerpt from "../components/topic-list-excerpt";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("topic-list-before-category", <template>
    <TopicListExcerpt
      @outlet="topic-list-before-category"
      @topic={{@outletArgs.topic}}
    />
  </template>);
});
